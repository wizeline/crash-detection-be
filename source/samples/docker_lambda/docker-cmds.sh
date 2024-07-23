
docker build --tag crash-detection-sample-docker-function .
docker run -td -p 9000:8080 --env-file .env --name=crash-detection-sample-docker-function crash-detection-sample-docker-function


docker cp ./cli.py crash-detection-sample-docker-function:/var/task
docker cp ./helpers.py crash-detection-sample-docker-function:/var/task
docker cp ./init.py crash-detection-sample-docker-function:/var/task

docker exec -it crash-detection-sample-docker-function sh -c "python cli.py"