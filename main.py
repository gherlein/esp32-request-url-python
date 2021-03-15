import boto3
from botocore.client import Config
import json
import uuid

def lambda_handler(event, context):
    bucket_name = 'esp32-rekognition-497939524935'
    file_name = str(uuid.uuid4()) + '.jpg'
    
    mqtt = boto3.client('iot-data', region_name='us-west-1')
    s3 = boto3.client('s3')

    url = s3.generate_presigned_url('put_object', Params={'Bucket':bucket_name, 'Key':file_name}, ExpiresIn=60, HttpMethod='PUT')
   
    d=json.dumps(event)
    tgt = d + ' ' + file_name + ' ' + repr(url) 
    response = mqtt.publish(
            topic='esp32/sub/url',
            qos=0,
            payload=tgt
        )
    return tgt

