#!/bin/bash
rm -rf target
mkdir -p target/pkg
pip install -r src/requirements.txt -t target/pkg
cp src/* target/pkg
cd terraform
terraform apply
rm -rf target/pkg



