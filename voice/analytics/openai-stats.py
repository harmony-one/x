import requests
from dotenv import load_dotenv
import os
load_dotenv()
from elasticsearch import Elasticsearch
import re
from datetime import datetime, timedelta

def get_gpt_stats(days_timeframe):
    bundle_id = os.getenv("BUNDLE_ID")
    api_key = os.getenv("APP_STORE_CONNECT_API_KEY")

    es = Elasticsearch(
        os.getenv("ELASTICSEARCH_URL"),
        http_auth=(os.getenv("ELASTICSEARCH_USER"), os.getenv("ELASTICSEARCH_PASS"))
    )

    current_time = datetime.utcnow()

    start_time = current_time - timedelta(hours=24*days_timeframe)

    start_time_str = start_time.strftime("%Y-%m-%dT%H:%M:%S.%fZ")
    current_time_str = current_time.strftime("%Y-%m-%dT%H:%M:%S.%fZ")

    query = {
        "track_total_hits": False,
        "sort": [
            {
                "time": {
                    "order": "desc",
                    "unmapped_type": "boolean"
                }
            }
        ],
        "fields": [
            {
                "field": "*",
                "include_unmapped": "true"
            },
            {
                "field": "time",
                "format": "strict_date_optional_time"
            }
        ],
        "size": 5000,
        "version": True,
        "script_fields": {},
        "stored_fields": [
            "*"
        ],
        "runtime_mappings": {},
        "_source": False,
        "query": {
            "bool": {
                "must": [],
                "filter": [
                    {
                        "range": {
                            "time": {
                                "format": "strict_date_optional_time",
                                "gte": start_time_str,
                                "lte": current_time_str
                            }
                        }
                    },
                    {
                        "exists": {
                            "field": "relayMode"
                        }
                    }
                ],
                "should": [],
                "must_not": []
            }
        },
        "highlight": {
            "pre_tags": [
                "@kibana-highlighted-field@"
            ],
            "post_tags": [
                "@/kibana-highlighted-field@"
            ],
            "fields": {
                "*": {}
            },
            "fragment_size": 2147483647
        }
    }


    response = es.search(body=query)

    with open('log1.txt', 'w') as writefile:
        writefile.write(str(response))

    response_tokens = 0
    request_tokens = 0

    conversation_ctr = 0

    sum_first_response_time = 0
    sum_total_response_time = 0

    for hit in response['hits']['hits']:
        request_tokens += hit['fields']['requestTokens'][0]
        response_tokens += hit['fields']['responseTokens'][0]
        conversation_ctr += 1
        sum_first_response_time += hit['fields']['firstResponseTime'][0]
        sum_total_response_time += hit['fields']['totalResponseTime'][0]

    cost = 0.03 * request_tokens / 1000 + 0.06 * response_tokens / 1000

    avg_first_response_time = (sum_first_response_time / conversation_ctr) / 1000000
    avg_total_response_time = (sum_total_response_time / conversation_ctr) / 1000000    

    return {
        'response_tokens': response_tokens,
        'request_tokens': request_tokens,
        # Model	Input	Output
        # gpt-4	$0.03 / 1K tokens	$0.06 / 1K tokens
        'est_cost': round(cost, 2),
        'queries': conversation_ctr,
        'avg_first_response_time': round(avg_first_response_time, 2),
        'avg_total_response_time': round(avg_total_response_time, 2)

    }

if __name__ == "__main__":
    stats = get_gpt_stats(1)
    print("{\n" + "\n".join("{!r}: {!r},".format(k, v) for k, v in stats.items()) + "\n}")