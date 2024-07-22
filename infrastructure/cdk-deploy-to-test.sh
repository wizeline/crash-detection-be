#!/usr/bin/env bash
# cdk-deploy-to-test.sh
cdk bootstrap aws://058264526494/us-west-2
./cdk-deploy-to.sh 058264526494 us-west-2 "$@"