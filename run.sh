#!/bin/sh
set -e
aws-es-proxy -listen :9200 -endpoint ${AWS_ES_ENDPOINT}
