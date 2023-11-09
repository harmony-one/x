## Production Checklist

### Nov 8, 2023

#### User Interface Bugs

- [ ] ~~User Guide is taking the user out of the app to Safari. It could open an in-app browser card (that can be closed by swiping down) instead~~ (no longer relevant since User Guide button is removed)
- [ ] Tap-to-speak is not cancelled by press-and-hold 
- [ ] Press-and-hold does not reset tap-to-speak

#### Audio Bugs

- [ ] Input and output devices are not updated, when new devices are connected and made as default audio device (e.g. when airpods are connected, the app still uses the speaker)
- [ ] Playback interrupts and pauses background audio (e.g. music), but does not resume background audio after playback is completed
- [ ] Playback sometimes stops functioning when default audio device is disconnected
- [ ] Playback sometimes stops functioning when airpods are switched between multiple devices (e.g. becomes active in a nearby computer, then switched back to the phone)
- [ ] If another app (e.g. phone) is exclusively occupying audio capturing (e.g. incoming phone call), and the app begins capturing (e.g. press Tap-to-speak or Press-and-hold while the phone call is ringing), the app would crash
- [ ] If another app is exclusively occupying audio playback (e.g. incoming phone call), the app's playback would be automatically paused, but the internal state would remain incorrect and the UI would show incorrect status. Multiple button-presses on Pause / Play button are required to recover from the incorrect state

#### Customer Support and Feedback

- [ ] Users are not presented with any information on where to get help 
- [ ] Users have no way to send a message to customer support (consider submitting voice messages, like Tesla)
- [ ] Users are not asked to review the app after using the app for a while, if they have not reviewed the app before

#### Version Control

- [ ] There is no record of which version of the code corresponding to which build version on TestFlight or App Store. Consider tagging each version, publish the tag on GitHub, and record the changes under "Releases", before distributing the app to TestFlight or App Store. 

### Nov 7, 2023

#### Multi-purpose

- [ ] Unique identification per user or device (e.g. [DCDevice](https://developer.apple.com/documentation/devicecheck/accessing_and_modifying_per-device_data))

The user id can be used for usage metering, analytics, error capturing (for debugging and support), and in future versions, relay-based rate limiting and fee metering

#### Usage metering and analytics

- [ ] Measuring user engagement
  - [ ] Session time
  - [ ] Response latency
  - [ ] Actions (opening app, buttons pressed, terminating app)
- [ ] Analyzing user engagement data 
  - [ ] Storage and accumulation
    - [ ] Google
    - [ ] Sentry
  - [ ] Data visualization and dashboards
    - [ ] Google / Sentry default dashboards (for basic information)

Granular measurements and analytics can be implemented in the upcoming versions:

- [ ] ElasticSearch (Storage and accumulation)
- [ ] Kibana (for revenue and contextual queries) (Data visualization and dashboards)
- [ ] Anonymized conversation (Measuring user engagement)
- [ ] Dialogue length (Measuring user engagement)

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