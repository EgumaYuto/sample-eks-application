#!/usr/bin/env bash

set -o pipefail
BASE_DIR=$(pwd)
TF_CMD=$1
ENV=$2
TARGET_DIRS=$3
TF_ARGS=${@:4}

ENV_CONFIG=$(cat "$BASE_DIR/_terraform_config/env_variables/$ENV.json")

cd $BASE_DIR/$TARGET_DIRS

TF_VAR_primary_env=$(echo $ENV_CONFIG | jq -r ".primary_env") \
TF_VAR_state_bucket=$(echo $ENV_CONFIG | jq -r ".state_bucket") \
TF_VAR_default_region=$(echo $ENV_CONFIG | jq -r ".default_region") \
TF_VAR_default_availability_zones=$(echo $ENV_CONFIG | jq -r ".default_availability_zones") \
TF_VAR_main_vpc_cidr_block=$(echo $ENV_CONFIG | jq -r ".main_vpc_cidr_block") \
terraform $1 $TF_ARGS


