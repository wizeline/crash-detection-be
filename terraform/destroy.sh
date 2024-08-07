#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function load_variables(){
    # Path to the source.env file
    SOURCE_ENV_FILE="${SCRIPT_DIR}/terraform.tfvars"

    # Check if the file exists
    if [[ ! -f "$SOURCE_ENV_FILE" ]]; then
    echo "File $SOURCE_ENV_FILE does not exist."
    exit 1
    fi

    while IFS='=' read -r key value; do
        # Strip any surrounding whitespace from the key and value
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        
        # Skip empty lines and comments
        if [[ -z "$key" || "$key" == \#* ]]; then
            continue
        fi

        # Prefix the variable with TF_VAR_ and export it
        export "TF_VAR_$key=$value"
        
        # Optional: Print the variable to confirm (for debugging purposes)
    done < "$SOURCE_ENV_FILE"
}

function empty_ecr() {
    REPOSITORY_NAME=$1
    output=$(aws ecr describe-repositories  --region $TF_VAR_aws_region  --repository-names ${REPOSITORY_NAME} 2>&1)
    if echo ${output} | grep -q RepositoryNotFoundException; then
        echo "> repository ${REPOSITORY_NAME} does not exists"
        return
    fi

    echo "Deleting ECR $REPOSITORY_NAME"
    image_ids=$(aws ecr list-images --region $TF_VAR_aws_region --repository-name $REPOSITORY_NAME --query 'imageIds[*]' --output json)
    if [ "$image_ids" != "[]" ]; then
        echo "Deleting images from ECR $REPOSITORY_NAME"
        aws ecr batch-delete-image \
                --region $TF_VAR_aws_region \
                --repository-name $REPOSITORY_NAME \
                --image-ids $image_ids \
            &> /dev/null
    fi
   aws ecr delete-repository --region $TF_VAR_aws_region --repository-name $REPOSITORY_NAME --force  &> /dev/null 
}

function empty_bucket() {
    BUCKET_NAME=$1
    output=$(aws s3 ls s3://$BUCKET_NAME 2>&1)
    if echo ${output} | grep -q NoSuchBucket; then
        echo "> bucket ${BUCKET_NAME} does not exists"
        return
    fi
    aws s3 rm s3://$BUCKET_NAME --recursive
}

function main () {

    load_variables

    empty_bucket ${TF_VAR_prefix}$TF_VAR_s3_raw_videos_bucket_name
    empty_bucket ${TF_VAR_prefix}$TF_VAR_s3_chunked_videos_bucket_name

    empty_ecr ${TF_VAR_prefix}$TF_VAR_ecr_chunk_videos_repository_name
    empty_ecr ${TF_VAR_prefix}$TF_VAR_ecr_detect_collission_repository_name


    cd $SCRIPT_DIR
    terraform refresh
    terraform destroy -auto-approve

}

# entry point 
main "$@"
