#!/usr/bin/env python
import os
import json

from flask import Flask, Response
from elasticsearch import Elasticsearch

ELASTICSEARCH_INDEX = os.environ.get('ELASTICSEARCH_INDEX', 'gifs')

if 'ELASTICSEARCH_HOST' in os.environ:
    hosts = [
        {'host': os.environ['ELASTICSEARCH_HOST'], 'port': int(os.environ.get('ELASTICSEARCH_PORT', 9200))}
    ]
else:
    hosts = None

app = Flask(__name__)
es = Elasticsearch(hosts=hosts)


@app.route('/ping')
def ping():
    return "pong"


@app.route('/get-gifs')
def hello():
    res = es.search(index=ELASTICSEARCH_INDEX, body={"query": {"match_all": {}}})
    return Response(
    	json.dumps([hit['_source'] for hit in res['hits']['hits']]), 
    	mimetype='application/json'
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
