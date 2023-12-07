## Infrastructure

In addition to the client app itself, several systems are used for metric collection during development and in production:

1. ElasticSearch, used for storing measurements, associated metadata, and messages. ElasticSearch is deployed on GCP as a container VM at `es.x.country`
2. Kibana, used for visualizing the data stored in ElasticSearch and creating dashboards.  Kibana is deployed on GCP in a separate container VM at `kibana.x.country`
3. Relay, used for logging events, validating client (app) requests, issuing temporary tokens, and communicating with other systems both externally (such as OpenAI) and internally (such as ElasticSearch). Relay is deployed on GCP in a separate Debian VM at `x-country-app-relay.hiddenstate.xyz`

A few other systems are used for collecting events and errors in user interactions:

1. Mixpanel, primarily for collecting usage statistics for different app functionalities
2. Sentry, primarily used for capturing errors and its execution stack, context, and environment

Very soon, for collecting realistic measurements without using real users, we may use some testing solutions prior to production deployment:

1. [UserTesting](https://www.usertesting.com/)
2. [Sofy](https://sofy.ai)

Both solutions enable us to upload an app package, and to test the pre-release app with a large number of professional testers using a variety of devices, operating system versions, network conditions, languages, and geographical locations.

## Measurements

For each user interaction, we may record multiple measurements along with metadata and store them all as one "document" in ElasticSearch

### Time measurements

We are interested in measuring the delay between when the user initiates a voice interaction, and when they receive some responses. The response could be an error or some intelligent feedback from the AI. We are also interested in the total duration of the interaction, that is, until the response naturally completes or gets cancelled by the user or some error.

First, we define a few points of time in the lifetime of a user interaction

1. `APP-REC`: When the user indicates they want to start a conversation. Based on the current app design, this is when the user tap the button "Press & Hold" or "Tap to Speak"
2. `SST-REC`: When the app begins capturing audio signals that is supposedly containing the user's speech content
3. `SST-STEP-N`: When the 1st, 2nd, 3rd, 4th, 5th, ... words the user have spoken are recognized and converted to text. They can be denominated as T3.0, T3.1, T3.2, T3.3, T3.4, ...
4. `APP-REC-END`: When the user indicates they finished speaking. Based on the current app design, this is when the user releases the "Press & Hold" button, or when "Tap to SEND" is tapped
5. `SST-REC-END`: When the app stops capturing audio signals
6. `SST-END`: When all the user's input speech signals are converted to text
7. `APP-SEND`: When the text and surrounding context are encapsulated in a request, and is sent to Relay for processing
8. `RLY-ACK`: When the Relay receives the request from client
9. `RLY-SEND`: When the Relay finishes validating the request and begins sending the request to an inference vendor such as OpenAI
10. `RLY-STEP-N` : When the Relay receives the 1st, 2nd, 3rd, 4th, 5th, ... tokens from the inference vendor and immediately forward the response to the app. They can be denoted by T10.0, T10.1, T10.2, T10.3, T10.4, ...
11. `RLY-END`: When the Relay receives the end-of-response signal from the inference vendor and immediately signals the app for end-of-response.
12. `APP-RES-N`: When the app receives the 1st, 2nd, 3rd, 4th, 5th, ... tokens from the vendor. They can be denoted by as T12.0, T12.1, T12.2, T12.3, T12.4, ...
13. `APP-RES-END`: When the app receives the end-of-response signal from the Relay.
14. `TTS-INIT`: When the app determines it has received sufficient tokens, grouped them into words, and is ready to begin synthesizing the words into audio signal
15. `TTS-STEP-N`: When the app finishes synthesizing 1st, 2nd, 3rd, 4th, 5th, ... words as audio. They can be denoted by T15.0, T15.1, T15.2, T15.3, T15.4, ...
16. `TTS-END`: When the app finishes synthesizing all output words
17. `APP-PLAY-N`: When the app begins playing 1st, 2nd, 3rd, ... words' audio.
18. `APP-PLAY-END`: When the app finishes playing all output audio
19. `APP-END`: When the app signals it has completed audio playback and is now ready and waiting for another user interaction
20. `APP-ERROR`: When the interaction is interrupted and terminated by some error in the app
21. `APP-CANCEL`: When the interaction is cancelled by the user

Note that the actual event sequence does not necessarily follow the above numerical order. For example, `APP-REC-END` could occur before `SST-STEP-N` occurs for some N. Below is table illustrating the concurrency between different components (`APP-ERROR` and `APP-CANCEL` could occur at any time):

| App                         | SST          | Relay        | TTS          |
|-----------------------------|--------------|--------------|--------------|
| APP-REC                     |              |              |              |
|                             | SST-REC      |              |              |
|                             | SST-STEP-1   |              |              |
| APP-REC-END                 | SST-STEP-2   |              |              |
|                             | SST-STEP-... |              |              |
|                             | SST-END      |              |              |
| APP-SEND                    |              |              |              |
|                             |              | RLY-ACK      |              |
|                             |              | RLY-SEND     |              |
|                             |              | RLY-STEP-1   |              |
| APP-RES-1                   |              | RLY-STEP-2   |              |
| APP-RES-2                   |              | RLY-STEP-... | TTS-INIT     |
| APP-RES-3                   |              | RLY-END      | TTS-STEP-1   |
| APP-RES-... <br> APP-PLAY-1 |              |              | TTS-STEP-2   |
| APP-RES-END <br> APP-PLAY-2 |              |              | TTS-STEP-... |
| APP-PLAY-3                  |              |              | TTS-END      |
| APP-PLAY-...                |              |              |              |
| APP-PLAY-END                |              |              |              |
| APP-END                     |              |              |              |

With the timeline and notation established, we can define some metrics. We need not to get the timestamp for everything above and measure time elapsed for any two pairs. That would be too many metrics, mostly useless, and introduces challenging issues such as the lack of synchronization between server and client clock and timestamps. 

Instead, time elapsed should be measured within the same component (App, SST, Relay, TTS). Note that under the present design, App, SST, and TTS are all on the client side, so time elapsed between different events can be measured across components. Only Relay is on the server side. 

The key measurements we need to look at are the following:

1. `[APP-REC, SST-REC]`: time elapsed to set up audio and speech recognition for an interaction
2. `[SST-REC, SST-END]`: time consumed by speech recognition
3. `[SST-END, APP-SEND]`: time spent on preparing the data and the request to relay, this could include time spent on serializing the data, attaching keys, and signing the request (coming soon) 
4. `[APP-SEND, APP-RES-1]`: time elapsed until the client receives the first response from Relay. 
   - As of now, this is measured as `firstResponseTime` in `bot-client-usage-v1` index. 
5. `[RLY-ACK, RLY-SEND]`: time spent at the Relay to pre-process the request (such as validation, key verification), before sending it to inference vendor (e.g. OpenAI)
6. `[RLY-SEND, RLY-STEP-1]`: time elapsed until Relay receives the first response from the inference vendor. 
   - As of now, this is measured as `firstResponseTime` in `bot-token-usage-v1` index.
7. `[RLY-SEND, RLY-END]`: time spent at the Relay to receive the entire response from the inference vendor. 
   - As of now, this is measured as `totalResponseTime` in `bot-token-usage-v1` index.
8. `[APP-SEND, APP-RES-END]`: time elapsed until the client receives the entire response from Relay. 
   - As of now, this is measured as `totalResponseTime` in `bot-client-usage-v1` index.
9. `[APP-RES-1, TTS-INIT]`: time elapsed to set up speech synthesis and to prepare a sufficiently long chunk of words for initial synthesis
10. `[TTS-INIT, TTS-STEP-1]`: time consumed by speech synthesizer to produce the first audio buffer
11. `[TTS-STEP-1, APP-PLAY-1]`: time consumed by playback system to parse and begin playing the first audio buffer
12. `[APP-RES-1, APP-PLAY-1]`: time elapsed between receiving server response to begin playing audio response. This is useful if the synthesizing system does not provide internal API to pinpoint `TTS-INIT` and `TTS-STEP-1`, otherwise it would be just the sum of `[APP-RES-1, TTS-INIT]`, `[TTS-INIT, TTS-STEP-1]`, and `[TTS-STEP-1, APP-PLAY-1]`
13. `[TTS-INIT, TTS-END]`: total time consumed by speech synthesizer to process the entire response
14. `[APP-RES-1, APP-PLAY-END]`: total time elapsed to synthesize the entire response as audio and play it

Additionally, if `APP-ERROR` or `APP-CANCEL` occurs in between any of the above measurement, the measurement for time elapsed should be recorded with `APP-ERROR` or `APP-CANCEL` as the termination timestamp, with corresponding flags `completed` set to false and `cancalled` set to whether `APP-CANCEL` occurred, and `error` field set to an informative message explaining the error, if there is any.

### Metadata

First, we need a unique, consistent id to identify a user that we can associate with the measurements. We are using two values to achieve this purpose:

1. `attestationHash`: The hash of the app attestation signed by Apple (based on key id generated at client, and randomly generated challenge value provided by Relay). This value is persisted at the app and is unlikely to change unless the user clears all app data, or when the user's device changes, or the user upgrades its iOS version. The attestation is verified by Relay when it issues a temporary authentication to the app. Whenever the app sends API requests (such as OpenAI completion call) to the Relay using the authentication token, the corresponding `attestationHash` value would be retrieved by Relay and added to the request.  
2. `deviceTokenHash`: The hash of device token, signed by Apple and verified by Relay at each request (with a long duration memory-based cache). The device token is unique to a device. The token is attached to every request for recording the measurements when they are sent from the app to the Relay. 

As a result, `attestationHash` is used to identify the user for Relay-vendor measurements (as used in `bot-token-usage-v1` index), and `deviceTokenHash` is used to identify the user for app client-side measurements (as used in `bot-client-usage-v1` index). At present this creates some difficulty aligning the records and measurements. In the near future we may include `deviceTokenHash` in Relay-vendor measurements as well, by making the app include device token in API calls to the Relay, and to have Relay associate `deviceTokenHash` and `attestationHash` at the server side as well

Secondly, longer requests and responses likely lead to longer delay and overall decreased user experience. Because of that, we should measure the length of the request and response along with the recorded measurements.

Relevant values are:

1. `requestTokens`: The number of tokens present in the current inference request (e.g. for OpenAI chat completion call), including the context. In English the number of tokens roughly equal to the number of words (plus punctuations), but it is more nuanced in other languages. Moreover, this value is much less than `prompt_tokens` provided by OpenAI, since OpenAI tokenize words at a more granular level.
2. `responseTokens`: The number of tokens in the response. This value should equal to the value provided by OpenAI, since it can be accurately and efficiently calculated (OpenAI streaming produces one token for each chunk)
3. `requestNumMessages`: Total number of chat messages in the current request, including the context
4. `requestNumUserMessages`: Total number of chat messages from the user in the current request

In addition, we also record the text content in the request and response. The text is automatically analyzed by ElasticSearch, so we may later use the field to identify top words and phrases in queries.

## Client-side Implementation

See [TimeLogger](https://github.com/harmony-one/x/blob/a9ab785279a76b558b4e6b5c06ddac259082f6eb/voice/voice-ai/x/Performance/TimeLogger.swift) and how it is used in [OpenAIStreamService](https://github.com/harmony-one/x/blob/a9ab785279a76b558b4e6b5c06ddac259082f6eb/voice/voice-ai/x/OpenAIService/OpenAIStreamService.swift#L17C40-L17C40). To add more fields, both the `log` function and `struct ClientUsageLog` in `RelayAuth` need to be extended. More functions need to be added to hold temporary measurements, and `log` function can be transformed into a function without parameter that acts as a "final action" to write the record. 

Tips: After TimeLogger is extended and made stateful, an instance of TimeLogger can be created and passed around in different classes such as SpeechRecognition, ActionView, and other modules. An id could be added to each end-to-end user interaction and used across classes to alleviate concurrency issues.    

## ElasticSearch Indexes, Roles, Users, Access

### Indexes

See [client-usage.json](https://github.com/harmony-one/x/blob/a9ab785279a76b558b4e6b5c06ddac259082f6eb/voice/relay/src/services/schemas/client-usage.json) and [token-usage.sjon](https://github.com/harmony-one/x/blob/a9ab785279a76b558b4e6b5c06ddac259082f6eb/voice/relay/src/services/schemas/token-usage.json) for current ElasticSearch index mapping definitions.

The corresponding indexes in production are `bot-client-usage-v1` and `bot-token-usage-v1`

**IMPORTANT**: Please update the mapping with more fields before indexing new data (with new fields) to ElasticSearch. See [Update Mapping API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html). Failure to do so would make ElasticSearch automatically infer the type of the new field when new data is indexed, and most of the time the inference is wrong and the index would be stuck with an incorrectly typed field.

Please also update the json files as mapping fields get updated 

### Roles

### Users

### Access
TBD. Please request for access manually at this time.

## Kibana Dashboards and Visualizations

TBD