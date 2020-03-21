import json
import boto3
from chalice import Chalice, Response

app = Chalice(app_name='upload_to_s3')

S3 = boto3.client('s3', region_name='us-west-1')
BUCKET = 'my-bucket'


# El nombre del archivo lo envias con la extrension (ej. test.png)
@app.route('/upload/{file_name}', methods=['PUT'], content_types=['application/octet-stream'])
def upload_to_s3(file_name):
    body = app.current_request.raw_body
    tmp_file_name = '/tmp/' + file_name
    with open(tmp_file_name, 'wb') as tmp_file:
        tmp_file.write(body)

    # Estoy subiendo el archivo como publico, si no se desea quitar los ExtraArgs
    S3.upload_file(tmp_file_name, BUCKET, file_name, ExtraArgs={'ACL':'public-read'})

    response = {
        'message': 'The file %s was uploaded' % file_name
    }
    return Response(body=response, status_code=200)