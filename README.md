# crash-detection-be
Ferrovial Crash Detection PoC

## Run locally

### Configure Python Virtual Environment
```
$ python3 -m venv .venv
$ source .venv/bin/activate
$ cd src
$ pip install -r requirements.txt
```

### Run lambda in VSCode

In Visual Studio Code, navigate to `RUN AND DEBUG` and execute either `Debug chunk_videos_lambda_function.py` or `Debug detect_collision_lambda_function.py`

## Configure Terraform

(!) Note: All the resources are prefixed with the value of the variable "prefix" defined in  [terraform.tfvars](terraform.tfvars)

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

