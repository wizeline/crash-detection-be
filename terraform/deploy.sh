#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$SCRIPT_DIR/..
TARGET_DIR=$ROOT_DIR/target
SRC_DIR=$ROOT_DIR/src
PACKAGE_DIR=$TARGET_DIR/pkg

rm -rf $TARGET_DIR
mkdir -p $PACKAGE_DIR
pip install -r $SRC_DIR/requirements.txt -t $PACKAGE_DIR
cp $SRC_DIR/* $PACKAGE_DIR
cd $SCRIPT_DIR
terraform init
terraform apply



