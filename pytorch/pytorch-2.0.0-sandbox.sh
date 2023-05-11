#!/bin/bash

# version
version="2.0.0"

# build
apptainer build --sandbox pytorch-$version pytorch-${version}.def
