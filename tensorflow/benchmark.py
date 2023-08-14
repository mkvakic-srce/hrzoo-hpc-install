#!/usr/bin/env python3

# source:
# - https://github.com/leondgarse/Keras_insightface/discussions/17

import sys
import time
import argparse
import numpy as np
import tensorflow as tf

# input arguments
parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("-s",
                    "--strategy",
                    type=int, help="{1: OneDeviceStrategy, 2: MirroredStrategy}",
                    default=1)
parser.add_argument("-i",
                    "--images",
                    type=int,
                    help="image number",
                    default=1024)
parser.add_argument("-b",
                    "--batch_size",
                    type=int,
                    help="batch size",
                    default=8)
parser.add_argument("-e",
                    "--epochs",
                    type=int,
                    help="epochs",
                    default=10)
parser.add_argument("-m",
                    "--model_name",
                    type=str,
                    help="model name",
                    default="ResNet50")
parser.add_argument("-f",
                    "--use_fp16",
                    action="store_true",
                    help="Use fp16")
args = parser.parse_known_args(sys.argv[1:])[0]

# do not allocate all GPU memory
gpus = tf.config.experimental.list_physical_devices('GPU')
for gpu in gpus:
    tf.config.experimental.set_memory_growth(gpu, True)

# use fp16 for faster inference
if args.use_fp16:
    tf.keras.mixed_precision.set_global_policy('mixed_float16')

# strategy
gpus = tf.config.experimental.list_physical_devices('GPU')
devices = [ gpu.name[-5:] for gpu in gpus ]
if args.strategy == 2:
    strategy = tf.distribute.MirroredStrategy(devices=devices)
else:
    strategy = tf.distribute.OneDeviceStrategy(device=devices[0])

# dummy dataset
batch_size = args.batch_size * strategy.num_replicas_in_sync
data = np.random.uniform(size=[args.images, 224, 224, 3])
target = np.random.uniform(size=[args.images, 1], low=0, high=999).astype("int64")
dataset = tf.data.Dataset.from_tensor_slices((data, target)).batch(batch_size)

# define model
with strategy.scope():
    model = getattr(tf.keras.applications, args.model_name)(weights=None)
    opt = tf.optimizers.SGD(0.01)
    model.compile(optimizer=opt,
                  loss=tf.keras.losses.SparseCategoricalCrossentropy())

# fit
callbacks = []
model.fit(dataset,
          callbacks=callbacks,
          epochs=args.epochs,
          verbose=2)
