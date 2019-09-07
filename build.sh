#!/bin/bash

mkdir build
cd build
cmake -DBUILD_TESTS=OFF -DWITH_PYTHON=OFF ..
sudo make install