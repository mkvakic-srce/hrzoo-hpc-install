#!/bin/bash

# version
version="1.8.0-ngc"

# build
apptainer build --sandbox pytorch-$version pytorch-${version}.def
