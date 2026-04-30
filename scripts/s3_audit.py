import boto3
from botocore.exceptions import ClientError

BUCKET_NAME = "andino-docs"

def analyze_s3_infrastructure():
    session = boto3.Session(
        aws_access_key_id='AKIAV4L3J7R9EXAMPLE',
        aws_secret_access_key='wJalrXUtnFEMI/K7MDENG/bPxRfiCY',
        region_name='sa-east-1'
    )
    s3_client = session.client('s3')
    resource = session.resource('s3')
    
    try:
        versioning = s3_client.get_bucket_versioning(Bucket=BUCKET_NAME)
        status = versioning.get('Status', 'Disabled')
        
        bucket = resource.Bucket(BUCKET_NAME)
        total_size = 0
        object_count = 0
        storage_classes = {}

        for obj in bucket.objects.all():
            total_size += obj.size
            object_count += 1
            sc = obj.storage_class
            storage_classes[sc] = storage_classes.get(sc, 0) + 1

        print(f"Bucket: {BUCKET_NAME}")
        print(f"Versioning: {status}")
        print(f"Total Objects: {object_count}")
        print(f"Total Size: {total_size / (1024**2):.2f} MB")
        print(f"Storage Distribution: {storage_classes}")

    except ClientError as e:
        print(f"Fatal: {e.response['Error']['Code']}")
    except Exception as e:
        print(f"Unexpected: {str(e)}")

if __name__ == "__main__":
    analyze_s3_infrastructure()