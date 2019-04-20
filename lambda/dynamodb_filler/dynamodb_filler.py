"""
A very basic DynamoDB filler
For demo purpose only
"""

import boto3
import os
import uuid
from datetime import datetime

TABLE = 'TABLE_NAME'
FIRST = 'first_name'
LAST = 'last_name'


def insert_into_db(event: dict) -> dict:
    """
    Insert a user item into DynamoDB
    :param event: (dict) Lambda event
    :return: (dict)
    """

    if TABLE not in os.environ:
        raise TypeError('No table name defined into environment variables')

    first_name = event[FIRST] if FIRST in event else 'John'
    last_name = event[LAST] if LAST in event else 'Doe'

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.environ[TABLE])
    table.put_item(Item={'id': int(datetime.timestamp(datetime.now())),
                         'uuid': str(uuid.uuid4()),
                         'insert_from': os.environ['AWS_REGION'],
                         'first_name': first_name,
                         'last_name': last_name})

    return {'statusCode': 200,
            'insert_from': os.environ['AWS_REGION'],
            'text': f'Successfully insert {first_name} {last_name}'}


def lambda_handler(event, context) -> dict:
    """
    Generic Lambda handler
    :param event: (dict) Lambda event
    :param context: (dict)
    :return: (dict)
    """
    return insert_into_db(event=event)
