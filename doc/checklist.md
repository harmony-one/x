## Production Checklist

### Nov 7, 2023

#### Multi-purpose

- [ ] Unique identification per user or device (e.g. [DCDevice](https://developer.apple.com/documentation/devicecheck/accessing_and_modifying_per-device_data))

The user id can be used for usage metering, analytics, error capturing (for debugging and support), and in future versions, relay-based rate limiting and fee metering

#### Usage metering and analytics

- [ ] Measuring user engagement
  - [ ] Session time
  - [ ] Response latency
  - [ ] Dialogue length
  - [ ] Actions (opening app, buttons pressed, terminating app)
  - [ ] Content (anonymous)
- [ ] Analyzing user engagement data 
  - [ ] Storage and accumulation
    - [ ] Google
    - [ ] Sentry
    - [ ] ElasticSearch
  - [ ] Data visualization and dashboards
    - [ ] Google / Sentry default dashboards (for basic information)
    - [ ] Kibana (for revenue and contextual queries)

#### Error capturing

- [ ] Sentry integrations
  - [ ] OpenAI API calls
    - [ ] Request failures
      - [ ] Network issues
      - [ ] API key issues
      - [ ] Rate limiting
    - [ ] Response irregularities
      - [ ] JSON parsing
      - [ ] Unrecognizable results
      - [ ] Timeouts
      - [ ] Remote termination
  - [ ] Audio operations
    - [ ] Engine and session setup and teardown
    - [ ] Capturing
      - [ ] Start
      - [ ] Stop
      - [ ] Speech recognition (start / stop exceptions, or errors in callback)
      - [ ] Data issues (e.g. empty buffer)
    - [ ] Playback
      - [ ] Start
      - [ ] Pause
      - [ ] Stop
      - [ ] Synthesis errors (enqueuing exceptions or callback errors)
  - [ ] Permission request errors (microphone, speech recognition)
  - [ ] User action handling exceptions

#### Rate limiting

- [ ] Client-side basic anti-spamming
  - [ ] Debouncing spam-prone actions (e.g. random fact)
  - [ ] Basic counter-based limit on queries-per-minute 

Other rate limiting techniques will be implemented in future versions (relay based)

#### Tests

TODO