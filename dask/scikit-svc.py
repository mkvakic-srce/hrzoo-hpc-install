# source
# https://ml.dask.org/joblib.html#scikit-learn-joblib

import os
import time
import joblib
import pprint
import numpy as np

from dask.distributed import Client

from sklearn.datasets import load_digits
from sklearn.model_selection import RandomizedSearchCV
from sklearn.svm import SVC

def main():

    # client
    client = Client(os.environ['SCHEDULER_ADDRESS'])

    # data
    digits = load_digits()

    # model
    param_space = {
        'C': np.logspace(-6, 6, 30),
        'tol': np.logspace(-4, -1, 30),
        'gamma': np.logspace(-8, 8, 30),
        'class_weight': [None, 'balanced'],
    }
    model = SVC(kernel='rbf')
    search = RandomizedSearchCV(model,
                                param_space,
                                cv=3,
                                n_iter=3000,
                                verbose=2)

    # fit
    with joblib.parallel_backend('dask'):
        search.fit(digits.data,
                   digits.target)

    # shutdown
    client.shutdown()

if __name__ == '__main__':
    main()
