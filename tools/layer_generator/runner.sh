#!/bin/bash

container_name=lambda_docker
docker_image=layer_builder

# Initialize default values
output="python"
requirements=""

# Function to display usage
usage() {
    echo "Usage: $0 -r <requirements> [-o <output>]"
    echo "  -r, --requirements  Specify the requirements file full path (mandatory)"
    echo "  -o, --output        Specify the output (optional, default: python), the file will have the .zip ext and will be located at layers folder"
    echo "  --help              Display this help message"
    exit 1
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -r|--requirements)
            requirements="$2"
            shift 2
            ;;
        -o|--output)
            output="$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown parameter passed: $1"
            usage
            ;;
    esac
done

# Check if mandatory requirements argument is provided
if [[ -z "$requirements" ]]; then
    echo "Error: -r or --requirements is mandatory."
    usage
fi

# Display the parsed arguments
echo "Requirements: $requirements"
echo "Output: $output"


ARCH=$(arch)
if [ "$ARCH" = "aarch64" ]; then
    ARCH=arm64
    docker build --platform=linux/arm64 --tag $docker_image .
else
    ARCH=x86_64
    docker build --platform=linux/amd64 --tag $docker_image .
fi

docker run -td --name=$container_name $docker_image
docker cp $requirements $container_name:/tmp/requirements.txt

docker exec -i $container_name /bin/bash < ./docker_install.sh
docker cp $container_name:/tmp/python.zip ../layers/$output.zip
docker stop $container_name
docker rm $container_name

# x86_64
# arm64