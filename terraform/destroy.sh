#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
aws s3 rm s3://wizeline-cdf-video-raw --recursive
aws s3 rm s3://wizeline-cdf-video-chunks --recursive

cd $SCRIPT_DIR
terraform destroy