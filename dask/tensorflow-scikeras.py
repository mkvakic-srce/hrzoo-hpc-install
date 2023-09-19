# source
# - https://adriangb.com/scikeras/stable/quickstart.html

import os
import time
import pprint
import numpy as np

import tensorrt
from tensorflow import keras
from scikeras.wrappers import KerasClassifier

from dask.distributed import Client
from joblib import parallel_backend

from sklearn.datasets import make_classification
from sklearn.model_selection import GridSearchCV

def get_model(hidden_layer_dim, meta):
    # note that meta is a special argument that will be
    # handed a dict containing input metadata
    n_features_in_ = meta["n_features_in_"]
    X_shape_ = meta["X_shape_"]
    n_classes_ = meta["n_classes_"]

    model = keras.models.Sequential()
    model.add(keras.layers.Dense(n_features_in_, input_shape=X_shape_[1:]))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(hidden_layer_dim))
    model.add(keras.layers.Activation("relu"))
    model.add(keras.layers.Dense(n_classes_))
    model.add(keras.layers.Activation("softmax"))
    return model

def main():

    # client
    client = Client(os.environ['SCHEDULER_ADDRESS'])

    # vars
    n_samples = 256*1000
    batch_size = 256
    max_epochs = 10

    # data
    X, y = make_classification(n_samples=1000,
                               n_features=20,
                               n_informative=10,
                               random_state=0)
    X = X.astype(np.float32)
    y = y.astype(np.int64)

    # clf
    clf = KerasClassifier(get_model,
                          loss="sparse_categorical_crossentropy",
                          hidden_layer_dim=100)

    # gs
    param_grid = {
        "hidden_layer_dim": [50, 100, 200],
        "optimizer": ["adam", "sgd"],
        "optimizer__learning_rate": [0.0001, 0.001, 0.1],
    }
    gs = GridSearchCV(clf,
                      param_grid=param_grid,
                      refit=False,
                      cv=3,
                      scoring='f1')

    # fit
    now = time.time()
    with parallel_backend('dask'):
        gs.fit(X, y, verbose=2)
    print('fit elapsed in %0.2f' % (time.time()-now))

    # shutdown
    client.shutdown()

if __name__ == "__main__":
    main()
