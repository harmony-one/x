from dotenv import load_dotenv
import os
import requests
from datetime import datetime, timedelta

# Load environment variables
load_dotenv()

# Sentry API endpoint and API key
sentry_api_base_url = "https://sentry.io/api/0"
api_key = os.getenv('SENTRY_TOKEN')

# Headers for authentication
headers = {
    "Authorization": f"Bearer {api_key}"
}


def get_prod_error_count(organization_slug, project_slug):
    """Get production error count from Sentry."""
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
        return len(response.json())
    else:
        raise Exception(f"Error: {response.status_code}")


def get_project_issues(organization_slug, project_slug):
    """Get project issues from Sentry."""
    endpoint = f"{sentry_api_base_url}/projects/{organization_slug}/{project_slug}/issues/"
    response = requests.get(endpoint, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"Error: {response.status_code}")


if __name__ == "__main__":
    organization_slug = "harmony-23"
    project_slug = "apple-ios"
    event_count = get_prod_error_count(organization_slug, project_slug)
    print(f"Count of events in the last 24 hours: {event_count}")
