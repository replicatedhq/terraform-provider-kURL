#!/usr/bin/env bash

echo "Have you setup your aws credentials or configuration?"
echo -n "y/n: "
read -r credentials
if [ "$credentials" = "n" ];  then
 aws configure
fi

echo "Do you want to store your terraform state to s3 bucket ?"
echo -n "y/n: "
read -r backend

if [ "$backend" = "y" ];  then
    echo "Have you created s3 bucket?"
    echo -n "y/n: "
    read -r s3

    if [ "$s3" = "y" ];  then
        echo "S3 Bucket Name?"
        echo -n "name: "
        read -r s3_name
        export S3_NAME="$s3_name"

        echo "Region of S3 bucket?"
        echo -n "ap-southeast-2: "
        read -r region
        export S3_REGION="$region"

        envsubst < backend.tf.tpl > backend.tf
    else
        echo "Please create your s3 bucket first"
    fi
else
    echo "Now you can run make init to run terraform init"
fi