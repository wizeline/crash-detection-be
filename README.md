# crash-detection-be
Ferrovial Crash Detection PoC

## Run locally
In VSCode, navigate to RUN AND DEBUG and execute `Debug chunk_videos_lambda_function.py`


### Configure Python Virtual Environment
```
$ python3 -m venv .venv
$ source .venv/bin/activate
$ cd src
$ pip install -r requirements.txt
```

### Run lambda in VSCode


## Configure Terraform

### Install Terraform (only once)

```
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
```

## Deploy to AWS
```
$ terraform/deploy.sh
```

## Destroy AWS infrastructure
```
$ terraform/destroy.sh

```

