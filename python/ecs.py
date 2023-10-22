import boto3
import dateutil
import os

access_key = os.environ.get("AWS_ACCESS_KEY_ID")
secret_key = os.environ.get("AWS_SECRET_ACCESS_KEY")
region = os.environ.get("AWS_REGION")
aws_region = 'us-east-1'  
bucket_name = 'ecsbucketandreprocope-dev'


ecs_cluster = 'nginx_cluster'
ecs_service = 'nginx_service'


s3 = boto3.client('s3', aws_access_key_id=access_key, aws_secret_access_key=secret_key, region_name=aws_region)

try:
    response = s3.list_objects_v2(Bucket=bucket_name)
    for obj in response.get('Contents', []):
        print(f'S3 Object: {obj["Key"]}, Size: {obj["Size"]} bytes')
except Exception as e:
    print(f"S3: An error occurred - {str(e)}")

ecs = boto3.client('ecs', aws_access_key_id=access_key, aws_secret_access_key=secret_key, region_name=aws_region)

try:
    task_definitions = ecs.list_task_definitions()
    print("ECS Task Definitions:")
    for task_def in task_definitions['taskDefinitionArns']:
        print(f'- {task_def}')

    services = ecs.list_services(cluster=ecs_cluster)
    print("ECS Services:")
    for service in services['serviceArns']:
        print(f'- {service}')
except Exception as e:
    print(f"ECS: An error occurred - {str(e)}")