#!/bin/bash
# virtualenv --python=/usr/local/bin/python python
# source python/bin/activate
# pip install -r requirements.txt -t python/lib/python3.11/site-packages

cd /tmp/
mkdir python
pip install -r requirements.txt -t python/

zip -r python.zip python/
# zip -r9 python.zip python