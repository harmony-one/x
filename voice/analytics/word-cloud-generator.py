import requests
from dotenv import load_dotenv
import os
load_dotenv()
from elasticsearch import Elasticsearch
import re
import json
import matplotlib.pyplot as plt
from wordcloud import WordCloud
from datetime import datetime, timedelta

bundle_id = os.getenv("BUNDLE_ID")
api_key = os.getenv("APP_STORE_CONNECT_API_KEY")

es = Elasticsearch(
    os.getenv("ELASTICSEARCH_URL"),
    http_auth=(os.getenv("ELASTICSEARCH_USER"), os.getenv("ELASTICSEARCH_PASS"))
)

current_time = datetime.utcnow()

start_time = current_time - timedelta(hours=24*1)

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

response_data = str(response)

with open("word-cloud-log.txt", 'w') as writefile:
    writefile.write(response_data)

pattern = r"user:.*?(?=(?:user:|assistant:|['\]]]|\")|$)"

matches = re.findall(pattern, response_data)

extracted_strings = []
for match in matches:
    match = match.replace("user:", "")
    hex = match.encode("utf-8").hex()
    hex = hex.replace("5c6e", "")
    bytes_data = bytes.fromhex(hex)
    match = bytes_data.decode("utf-8")
    extracted_strings.append(match)

word_freq_map = {}
for query in extracted_strings:
    words = query.split()
    
    for word in words:
        if word.lower() in ['the', 'are', 'from', 'wikipedia', 'in', 'and', 'you', 'of', 'can', 'and', 'me', 'to', 'what', 'for', 'the', 'how', 'it', 'tell', 'summarize', 'the', 'about', 'is', 'i', 'a', 'hello']:
            pass
        else:
            cleaned_word = word.strip('.,!?').lower()
            
            if cleaned_word in word_freq_map:
                word_freq_map[cleaned_word] += 1
            else:
                word_freq_map[cleaned_word] = 1

# for word, freq in word_freq_map.items():
#     print(f"{word}: {freq}")


## Word Cloud of frequency
wordcloud = WordCloud(font_path='arial-unicode-ms.ttf', width=2000, height=1500, background_color='white').generate_from_frequencies(word_freq_map)

plt.figure(figsize=(10, 6))
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis('off')
plt.title('Word Cloud')
plt.show()
