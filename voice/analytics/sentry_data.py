from dotenv import load_dotenv
import os
import requests

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
    query = '!event.type:transaction !message:"handleRecognitionError: " timestamp:-24h'
    endpoint = f"{sentry_api_base_url}/projects/{organization_slug}/{project_slug}/issues/"
    params = {
        'query': query,
        'environment': 'production'
    }

    response = requests.get(endpoint, headers=headers, params=params)

    if response.status_code == 200:
        error_count = 0
        for error in response.json():
            for period in error['stats']['24h']:
                error_count += period[1]
        return error_count
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
