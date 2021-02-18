"""An AWS Python Pulumi program"""

import pulumi
from pulumi_aws import s3
from pulumi_aws import Provider, ProviderEndpointArgs

mock_provider = Provider("moto",
    skip_credentials_validation= True,
    skip_metadata_api_check= True,
    skip_requesting_account_id = True,
    s3_force_path_style= True,
    access_key= "mockAccessKey",
    secret_key= "mockSecretKey",
    region= "eu-central-1",
    endpoints= [ProviderEndpointArgs(s3="http://127.0.0.1:5000")])

# Create an AWS resource (S3 Bucket)
bucket = s3.Bucket('my-bucket', __opts__=pulumi.ResourceOptions(provider=mock_provider))

# Export the name of the bucket
pulumi.export('bucket_name', bucket.id)
