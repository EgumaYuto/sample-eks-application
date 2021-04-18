#!/usr/bin/env bash

TF_CMD=$1
ENV=$2
TF_ARGS=${@:3}

./tf.sh $TF_CMD $ENV operation/bastion $TF_ARGS

./tf.sh $TF_CMD $ENV service/sample-api/api-gateway $TF_ARGS
./tf.sh $TF_CMD $ENV service/sample-api/ecs $TF_ARGS
./tf.sh $TF_CMD $ENV service/sample-api/elb $TF_ARGS
#./tf.sh $TF_CMD $ENV service/sample-api/ecr $TF_ARGS

./tf.sh $TF_CMD $ENV platform/ecs-cluster/main $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/main/subnet/private $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/main/subnet/public $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/main/vpc $TF_ARGS