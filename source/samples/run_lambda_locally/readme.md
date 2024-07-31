# Running AWS Lambda locally

This PoC is about running an AWS Lambda function locally.

The idea is to have access to a env. variable and also to a real S3 bucket.

## Option 1 - SAM-CLI

Prerequisite: Install aws-sam-cli
```
$ brew install aws-sam-cli
```

We need to define a [template.yaml](./template.yaml) with the related function. In this file we also define the env. variable `TARGET_BUCKET` that the lambda uses.

To execute it: 
```
$ cd sources/samples/run_lambda_locally
$ sam local invoke -e ../events/put-bucket.json
```

## Option 2 - test_handler.py (via VSCode & Python Debugger)

There is a launch configuration for that in the [launch.json](../../../.vscode/launch.json) file.

Prerequisite: Install Python Debugger VSCode Extension

1. create a `.env` file and
2. Navigate to `test_handler.py`
3. Run `Python Debugger: Current File` from Run & Debug





