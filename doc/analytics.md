# Source Overview

### Elasticsearch/Kibana
Logs of every request sent by the app to OpenAI. This includes OpenAI stats such as message, response, response time, tokens used, etc. Also logs benchmarking metrics (WIP).

### Sentry
Logs errors and groups similar errors into issues. Anytime the app experiences unexpected or bad behavior, an error message is emitted to Sentry. Similar errors are grouped into issues for combined investigation.

### App Store Connect
Reports app usage, downloads, and engagement analytics for all versions of the build. Separates stats by version (and user for TestFlight builds). App crashes are reported in App Store Connect because once the app has crashed, it can't emit an error to Sentry.

### Mixpanel
Tracks user interactions with the app to provide insights into user behavior and engagement. Mixpanel helps in understanding how users interact with different features and the overall usability of the app.


# Metrics Scripts
Located in x/voice/[analytics](https://github.com/harmony-one/x/blob/main/voice/analytics/README.md).

all_stats.py currently pulls the following from the last 24 hours. Please see README for more details. 
```
GPT Stats from Elastic Search
  Number of response tokens used
  Number of request tokens used
  Estimated cost
  Number of queries
  Average first response time
  Average total response time

App error stats from Sentry
  Number of errors in production (currently omitting handleRecognitionError)
  ```