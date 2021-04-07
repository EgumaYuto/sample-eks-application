#!/usr/bin/env bash

TF_CMD=$1
ENV=$2
TF_ARGS=${@:3}

./tf.sh $TF_CMD $ENV platform/network/service/subnet/private $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/service/subnet/public $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/service/vpc $TF_ARGS