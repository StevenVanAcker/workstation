#!/bin/bash

pushd ./files

find . | cpio -pd --no-preserve-owner --unconditional /

popd

