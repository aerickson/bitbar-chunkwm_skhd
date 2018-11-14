#!/usr/bin/env bash


set -e

ITERATIONS=10

echo "iterations: ${ITERATIONS}"
echo ""
echo "/// c"
time ./looper.sh ${ITERATIONS} './chunkwm_tool'
echo ""
echo "/// bash"
time ./looper.sh ${ITERATIONS} './chunkwm_skhd.1s.sh'