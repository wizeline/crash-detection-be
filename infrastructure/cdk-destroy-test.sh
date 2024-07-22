#!/usr/bin/env bash

export CDK_DEPLOY_ACCOUNT=058264526494
export CDK_DEPLOY_REGION="us-west-2"
shift; shift
cdk destroy "$1"
exit $?