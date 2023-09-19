# source
# https://examples.dask.org/machine-learning/training-on-large-datasets.html

import os
import time
import pprint

from dask.distributed import Client
import dask_ml.datasets
import dask_ml.cluster

def main():

    # spoji klijenta putem datoteke scheduler.json
    client = Client(os.environ['SCHEDULER_ADDRESS'])

    # kreiraj podatke
    n_clusters = 10
    n_samples = 10**7
    n_chunks = len(client.scheduler_info()['workers'])
    X, _ = dask_ml.datasets.make_blobs(centers = n_clusters,
                                       chunks = n_samples//n_chunks,
                                       n_samples = n_samples)

    # izračunaj
    km = dask_ml.cluster.KMeans(n_clusters=n_clusters)
    now = time.time()
    km.fit(X)
    print('GB: %f' % (int(X.nbytes)/1073741824))
    print('elapsed fit: %f' % (time.time()-now))

    # shutdown
    client.shutdown()

if __name__ == '__main__':
    main()
