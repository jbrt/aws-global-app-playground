"""
Very simple DynamoDB getter (for demo purpose only)
Research and returns items inserted few seconds ago
"""

import boto3
import os
from boto3.dynamodb.conditions import Key
from datetime import datetime, timedelta

TABLE = 'TABLE_NAME'
SECONDS = 'SECONDS_AGO'


def simpler_getter() -> dict:
    """
    Scan a dynamoDB table and returns last X items
    :return: (dict)
    """

    seconds = os.environ[SECONDS] if SECONDS in os.environ else 10
    if TABLE not in os.environ:
        raise TypeError('No DynamoDB table defined in environment variables')

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.environ[TABLE])
    now = int(datetime.timestamp(datetime.now()))
    seconds_ago = int(datetime.timestamp(datetime.now() - timedelta(seconds=seconds)))

    # Scan the DynamoDB table and looking for items
    response = table.scan(FilterExpression=Key('id').between(seconds_ago, now))
    items = response['Items']

    if items:
        return {
            'statusCode': 200,
            'read_from': os.environ['AWS_REGION'],
            'body': items
        }
    else:
        return {
            'statusCode': 404,
            'read_from': os.environ['AWS_REGION'],
            'body': [],
            'reason': f'No items insert on last {seconds} seconds'
        }


def lambda_handler(event, context) -> dict:
    """
    Lambda handler
    :param event: (dict) Lambda event
    :param context:
    :return: (dict)
    """
    return simpler_getter()
