import argparse
import os

import ray
from ray import air, tune
from ray.tune.schedulers import AsyncHyperBandScheduler
from ray.tune.integration.keras import TuneReportCallback

import tensorrt
import numpy as np
import tensorflow as tf
from tensorflow import keras


epochs = 10
batch_size = 256
samples = batch_size*10
num_classes = 1000

def train_mnist(config):

    # data
    X = np.random.uniform(size=[samples, 224, 224, 3])
    y = np.random.uniform(size=[samples, 1], low=0, high=999).astype("int64")
    dataset = tf.data.Dataset.from_tensor_slices((X, y))

    # model
    model = tf.keras.applications.ResNet50(weights=None)

    loss = tf.keras.losses.SparseCategoricalCrossentropy()

    optimizer = tf.optimizers.SGD(lr=config["lr"],
                                  momentum=config["momentum"])

    model.compile(optimizer=optimizer,
                  loss=loss,
                  metrics=["accuracy"])

    # fit
    model.fit(X,
              y,
              batch_size = batch_size,
              epochs = epochs,
              verbose = 0,
              callbacks = [TuneReportCallback({"mean_accuracy": "accuracy"})])

def main():

    # resources
    resources = ray.cluster_resources()
    gpus = int(resources['GPU'])
    cpus = int(resources['CPU'])
    resources_per_worker = {'GPU': 1,
                            'CPU': (cpus-1)//gpus}

    # scheduler
    sched = AsyncHyperBandScheduler(time_attr="training_iteration",
                                    max_t=400,
                                    grace_period=20)

    # tuner
    trainable = tune.with_resources(train_mnist,
                                    resources=resources_per_worker)

    param_space = {"threads": 2,
                   "lr": tune.uniform(0.001, 0.1),
                   "momentum": tune.uniform(0.1, 0.9)}

    tune_config = tune.TuneConfig(metric="mean_accuracy",
                                  mode="max",
                                  scheduler=sched,
                                  num_samples=10)

    run_config = air.RunConfig(name="exp",
                               stop={"mean_accuracy": 1e-4,
                                     "training_iteration": 100})

    tuner = tune.Tuner(trainable=trainable,
                       tune_config=tune_config,
                       run_config=run_config,
                       param_space=param_space)

    results = tuner.fit()

    print("Best hyperparameters found were: ", results.get_best_result().config)

if __name__ == "__main__":
    import ray
    ray.init(address='auto',
             _node_ip_address=os.environ['NODE_IP_ADDRESS'])
    main()
