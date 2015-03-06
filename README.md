# s3get

Lightweight S3 Download Tool in Golang, based on https://github.com/awslabs/aws-sdk-go

## Installation

    curl -L https://github.com/ttakezawa/s3get/releases/download/v1.0.0/s3get_1.0.0_$(uname -sm|tr \  _).tgz \
      | tar -zxC /usr/local/bin

## Usage

    s3get s3://your-bucket/path/to/object.zip > object.zip
    s3get --access_key AKIAIOSFODNN7EXAMPLE --secret_key wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY --region ap-northeast-1 s3://your-bucket/path/to/object.zip > object.zip

If the access key ID and secret access key are provided, it returns a basic
provider.

If credentials are available via environment variables, it returns an
environment provider.

If a profile configuration file is available in the default location and has
a default profile configured, it returns a profile provider.

Otherwise, it returns an IAM instance provider.
