"""An AWS Python Pulumi program"""

import pulumi
from pulumi_aws import s3
from pulumi_aws import Provider, ProviderEndpointArgs

def return_mock_provider():
    return Provider("moto",
        skip_credentials_validation= True,
        skip_metadata_api_check= True,
        skip_requesting_account_id = True,
        s3_force_path_style= True,
        access_key= "mockAccessKey",
        secret_key= "mockSecretKey",
        region= "eu-central-1",
        endpoints= [ProviderEndpointArgs(s3="http://127.0.0.1:5000")])


def create_bucket(name: str) -> s3.Bucket:
    return s3.Bucket(name, __opts__=pulumi.ResourceOptions(provider=mock_provider))

mock_provider = return_mock_provider()

for i in range(0,10):
    bucket = create_bucket(f"my-{i}-bucket-23")
    pulumi.export('bucket_name', bucket.id)
