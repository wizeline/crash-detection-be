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


## Configure Terraform

### Install Terraform (only once)

```
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
```

### Initialize Terraform (only once)
```
$ cd terraform
$ terraform init
```

## Deploy
```
$ ./deploy.sh
```


