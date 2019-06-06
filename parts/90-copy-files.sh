#!/bin/bash

# Copy some files over the filesystem

pushd ./files

find . | cpio -pd --no-preserve-owner --unconditional /

popd

