# pull official base image
FROM public.ecr.aws/lambda/python:3.12

# install dependencies
COPY ./requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

# Copy function code
COPY init.py ${LAMBDA_TASK_ROOT}
COPY helpers.py ${LAMBDA_TASK_ROOT}

# Set the CMD to your handler.
CMD [ "init.lambda_handler" ]