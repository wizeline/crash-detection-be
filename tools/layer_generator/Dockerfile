# FROM python:3.12.2-slim-bullseye
# FROM --platform=linux/arm64 public.ecr.aws/lambda/python:3.12
FROM --platform=linux/arm64 amazon/aws-lambda-python:3.12

# set work directory
# WORKDIR ${LAMBDA_TASK_ROOT}

# RUN apt-get update \
# && apt-get install -y zip

RUN dnf -y install zip

CMD [ "dummy.lambda_handler" ]

# RUN pip install virtualenv==20.25.0