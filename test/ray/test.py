import os
import ray
import time
import pprint

def main():
    ray.init()
    print('--- test.py: print cluster resources ---')
    pprint.pprint(ray.cluster_resources())

if __name__ == '__main__':
    main()
