#
# sources:
# 1) data - https://archive.ics.uci.edu/dataset/15/breast+cancer+wisconsin+original

import os
import glob
import numpy as np
import pandas as pd
import itertools

import ray
from ray import air, tune
from ray.air import Checkpoint, session
from ray.train.sklearn import SklearnTrainer

from sklearn.datasets import make_classification
from sklearn.model_selection import cross_validate
from sklearn.metrics import mean_squared_error, mean_absolute_error

from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neural_network import MLPClassifier

def get_estimators(estimators):
    for model, options in estimators.items():
        options_cross = itertools.product(*options.values())
        options_keys = options.keys()
        for options_row in options_cross:
            yield model(**{key: value for key, value in zip(options_keys, options_row)})

def cross_validate_config(config, data):

    # X, y
    df = data.to_pandas()
    X = df.drop(columns=['id-number', 'diagnosis'])
    y = df['diagnosis'].map({'M': 1, 'B': 0})

    # cv
    result = cross_validate(estimator=config['estimator'],
                            X=X,
                            y=y,
                            scoring="f1",
                            n_jobs=1)

    # output
    results = { "f1": result['test_score'].mean() }
    session.report(results)

def main():

    # train, test
    data = ray.data.read_csv('wdbc.data')
    train, test = data.train_test_split(test_size=0.2)

    # estimator space
    estimators = {
        SVC: {
            'kernel': ['linear',
                       'poly',
                       'rbf',
                       'sigmoid'],
            'C': [1,
                  4,
                  16],
        },
        DecisionTreeClassifier: {
            'max_depth': [None,
                          2,
                          8,
                          32],
            'splitter': ['best',
                         'random'],
        },
        KNeighborsClassifier: {
            'algorithm': ['auto',
                          'ball_tree',
                          'kd_tree',
                          'brute'],
            'weights': ['uniform',
                        'distance'],
        },
        MLPClassifier: {
            'hidden_layer_sizes': [10,
                                   40,
                                   160],
            'activation': ['identity',
                           'logistic',
                           'tanh'],
        },
    }
    estimators = list(get_estimators(estimators))

    # grid search
    trainable = tune.with_parameters(cross_validate_config, data=train)

    param_space = {"estimator": tune.grid_search(estimators),
                   "n_splits": 5}

    tune_config = tune.TuneConfig(metric="f1",
                                  mode="max")

    tuner = tune.Tuner(trainable=trainable,
                       param_space=param_space,
                       tune_config=tune_config)

    result_grid = tuner.fit()
    best_result = result_grid.get_best_result()
    print(best_result)
    print(best_result.config)

if __name__ == '__main__':
    import ray
    ray.init(address='auto',
             _node_ip_address=os.environ['NODE_IP_ADDRESS'])
    main()
