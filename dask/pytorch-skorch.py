# source
# - https://skorch.readthedocs.io/en/stable/user/quickstart.html

import os
import time
import pprint
import numpy as np

import torch
import torch.nn as nn
import torch.optim as optim

from dask.distributed import Client
from joblib import parallel_backend

from skorch import NeuralNetClassifier

from sklearn.datasets import make_classification
from sklearn.model_selection import GridSearchCV

class MyModule(nn.Module):
    def __init__(self, num_units=10, nonlin=nn.ReLU()):
        super().__init__()
        self.dense0 = nn.Linear(20, num_units)
        self.nonlin = nonlin
        self.dropout = nn.Dropout(0.5)
        self.dense1 = nn.Linear(num_units, num_units)
        self.output = nn.Linear(num_units, 2)

    def forward(self, X, **kwargs):
        X = self.nonlin(self.dense0(X))
        X = self.dropout(X)
        X = self.nonlin(self.dense1(X))
        X = self.output(X)
        return X

def main():

    # client
    client = Client(os.environ['SCHEDULER_ADDRESS'])

    # vars
    n_samples = 256*100
    batch_size = 256
    max_epochs = 10

    # data
    X, y = make_classification(n_samples, 20, n_informative=10, random_state=0)
    X = X.astype(np.float32)
    y = y.astype(np.int64)

    # net
    net = NeuralNetClassifier(module = MyModule,
                              max_epochs = max_epochs,
                              criterion = nn.CrossEntropyLoss,
                              batch_size = batch_size,
                              train_split = None,
                              device = 'cuda')
    # search
    search = GridSearchCV(net,
                          param_grid = {'max_epochs': [1, 3, 10, 30],
                                        'module__num_units': [1, 10, 100, 1000],
                                        'module__nonlin': [nn.ReLU(), nn.Tanh()]},
                          scoring = 'accuracy',
                          error_score = 'raise',
                          refit = False,
                          verbose = 3,
                          cv = 3)

    # fit
    now = time.time()
    with parallel_backend('dask'):
        search.fit(X, y)
    print('fit elapsed in %0.2f' % (time.time()-now))

    # shutdown
    client.shutdown()

if __name__ == "__main__":
    main()
