#!/usr/bin/env bash

TF_CMD=$1
ENV=$2
TF_ARGS=${@:3}

./tf.sh $TF_CMD $ENV platform/network/main/vpc $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/main/subnet/public $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/main/subnet/private $TF_ARGS
./tf.sh $TF_CMD $ENV platform/ecs-cluster/main $TF_ARGS