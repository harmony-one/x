from dotenv import load_dotenv
import os
load_dotenv()
import requests
from datetime import datetime, timedelta

# Sentry API endpoint
sentry_api_base_url = "https://sentry.io/api/0"

# Your Sentry API key
api_key = os.getenv('SENTRY_TOKEN')

# Headers for authentication
headers = {
    "Authorization": f"Bearer {api_key}"
}

def get_prod_error_count(organization_slug, project_slug):
    now = datetime.utcnow()
    start_time = now - timedelta(days=1)
    start_time_str = start_time.strftime('%Y-%m-%dT%H:%M:%S')

    query = '!event.type:transaction !message:"handleRecognitionError: "'

    endpoint = f"{sentry_api_base_url}/projects/{organization_slug}/{project_slug}/issues/"

    params = {
        'query': query,
        'statsPeriod': '24h',
        'environment': 'production'
    }

    response = requests.get(endpoint, headers=headers, params=params)
    if response.status_code == 200:
        data = response.json()
        return len(data)
    else:
        return f"Error: {response.status_code}"


def get_project_issues(organization_slug, project_slug):
    endpoint = f"{sentry_api_base_url}/projects/{organization_slug}/{project_slug}/issues/"
    response = requests.get(endpoint, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        return f"Error: {response.status_code}"


organization_slug = "harmony-23"
project_slug = "apple-ios"

# issues = get_project_issues(organization_slug, project_slug)
# print(issues)
if __name__ == "__main__":
    organization_slug = "harmony-23"
    project_slug = "apple-ios"
    event_count = get_prod_error_count(organization_slug, project_slug)
    print(f"Count of events in the last 24 hours: {event_count}")