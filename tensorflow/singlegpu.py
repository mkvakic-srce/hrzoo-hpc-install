#!/usr/bin/env python3

# source:
# - https://github.com/leondgarse/Keras_insightface/discussions/17

import sys
import time
import argparse
import numpy as np
import tensorflow as tf

def main():

    # vars
    batch_size = 256
    samples = 256 * 20
    epochs = 10

    # do not allocate all GPU memory
    gpus = tf.config.experimental.list_physical_devices('GPU')
    for gpu in gpus:
        tf.config.experimental.set_memory_growth(gpu, True)

    # use fp16 for faster inference
    tf.keras.mixed_precision.set_global_policy('mixed_float16')

    # strategy
    gpus = tf.config.experimental.list_physical_devices('GPU')
    devices = [ gpu.name[-5:] for gpu in gpus ]
    strategy = tf.distribute.OneDeviceStrategy(device=devices[0])

    # dataset
    data = np.random.uniform(size=[samples, 224, 224, 3])
    target = np.random.uniform(size=[samples, 1], low=0, high=999).astype("int64")
    dataset = tf.data.Dataset.from_tensor_slices((data, target))
    dataset = dataset.batch(batch_size*strategy.num_replicas_in_sync)

    # define model
    with strategy.scope():
        model = tf.keras.applications.ResNet50(weights=None)
        loss = tf.keras.losses.SparseCategoricalCrossentropy()
        optimizer = tf.optimizers.SGD(0.01)
        model.compile(optimizer=optimizer, loss=loss)

    # fit
    callbacks = []
    model.fit(dataset,
              callbacks=callbacks,
              epochs=epochs,
              verbose=2)

if __name__ == "__main__":
    main()
