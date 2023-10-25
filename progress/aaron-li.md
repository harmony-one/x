(Coming soon 10/22-10/24)
[x] Swift-based streaming Deepgram end-to-end integration
[x] Response-streaming OpenAI inegration
[ ] Streaming Play.ht synthesis 

2023-10-24 Tue (6.5h+): Fix issues with streaming ASR error handling, payload parsing, keep-alive, auto-resuming, and closing; Implementing OpenAI streaming response handling, piping ASR to OpenAI, streamed toke nresponse processing; Piping to Speech synthesizer for end-to-end demo; UI Button integration and implementation based on streamed components; Debugging, end-to-end testing of streaming ASR (Deepgram) + LM (OpenAI); Debugging capturing activation for AVCaptureSession and implementing workarounds; Implement basic measures to counter self-interference (pause listening while speaking), fine-tune parameters and sentence delimiting to compare model performance, deploy to TestFlight

2023-10-23 Tue (6h): Complete Deepgram integraiton; Research on audio buffer splitting and joining; Implement and debug stream ASR end-to-end; Research, debug, and fix issues related to native websocket continuous receiving errors, reconnects, and sending errors for various payloads (keepalive, data); Simplify JSON payload parsing and encoding; Research and implementations on audio buffer merging, splitting, metadata retrieval and computation, and raw buffer parsing and manipulation; Debug x.country preview issues, app store app internal user access issues; Discussion on development process, concurrent implementation structure, forks, and merges

2023-10-22 Mon (5h): Deepdive on Deepgram API option and experiemtnation; OpenAI streaming API research and issue review; Building websocket messaging around Deepgram streaming integration and error handling; Research on low level header files for settings related to audio encoding, sample rate, and others for configuring output buffer; Research on audio buffer manipulation and experimentation; Implementation of audio buffer data conversion; Review simjilar issues reported online related to merging and splitting audio buffer; debugging and testing

2023-10-21 Sun (5h): Deepdive on Deepgram API option and experiemtnation; OpenAI streaming API research and issue review; Building websocket messaging around Deepgram streaming integration and error handling; Research on low level header files for settings related to audio encoding, sample rate, and others for configuring output buffer; Research on audio buffer manipulation and experimentation; Implementation of audio buffer data conversion; Review simjilar issues reported online related to merging and splitting audio buffer; debugging and testing; Complete Deepgram integration;

2023-10-21 Sat (2.5h): Implementing ASR websocket integration, functions for basic commands and controls; Revisiting documentation on Core Audio streaming methods and determine the best implementation approach; Review AudioToolBox and related alternatives and evaluate; Reviewing and implementing AVCaptureSession and AVCaptureAudioDataOutput

2023-10-20 Fri (3h): Review Hey Julia code; Fix configuration issues, build, deploy on TestFlight and discuss minimal steps for continued development; Forking iOS development versions, reconfigure projects in each folder, and deploy Hey Eve

2023-10-19 Thu (0.5h): Manage new app bundle ids, Test Flight configurations, corresponding provisioning profiles, and internal tester groups.

2023-10-18 Wed (4.5h): Research on iOS audio, speech, networking (native websocket v. third-party libraries such as Starscream) capabilities across recent versions, market share, and optimal cutoff version; Experiment on native websocket and assess deficiencies; Research on Swift Package Manager v. Cocoapods for managing external dependencies; Review, build, and test new iOS code (#35); Manage and debug on iOS provisioning profiles, signing certificate requests, and distribution certificate; Debug and fix issues related to x.country redirects and email alias contract management.

2023-10-17 Tue (2.5h): Testflight fine-grained access, profile, certificate setup; Build and publish new versions; Test latest demos and debug; Voice provider API testing and debug.

2023-10-16 Mon (3.5h): Review code update (#25, #28), all progress updates and results; Debugging Swift dashboard UI mockup bugs, Swift extensions;
Review and test Swift UI mockup fixes; Review code updates (#26 willow e2e, #28 Safari support, #10 error handling, deployment fixes), recent demos
Review, test, and compare Swift websocket libraries and code; Code review #4 (audio player base, elevenlabs), #25 (gpt4 context and deepgram), #26 (voice detection), #27 (willow e2e) and related components; Test commercial TTS provider APIs.

2023-10-14 Sat: (2h) TestFlight build, launch, bug fixes, and configurations; Review Deepgram benchmark and documentations.

2023-10-13 Fri: (7h) Research and analysis on audio libraries and frameworks under react native and iOS native system (CoreAudio, AVFoundation), [write ups](https://github.com/harmony-one/x/blob/main/doc/audio.md), [boilerplate app setup](https://github.com/harmony-one/x/pull/21), and code review; Progress review; X app configuration, framework imports, permission updates; Manual x.country domain management, maintainer updates; Long-term renewal, and bug fixes.

2023-10-12 Thu: (1.5h) Research on AVFoundation, Apple audio session programming, web audio controls, react-native sound and expo AV.

2023-10-11 Wed: (5.5h) Code review and discussion of contributor all historical commits; Manual subdomain record management; Discussions on findings of Twilio voice, voice models, performance, technical limitations, and streaming techniques and capabilities; Analyze use cases, engineering requirements, product prioities, development plans; Research on Apple GPU and Metal inference capbility, on-device APIs, and performance.

2023-10-10 Tue: (1.5h) Deepgram review; Twilio voice review and research.

2023-10-09 Mon: (0.5h) General code review; Research note and documentation reivew; React native app setup and Test Flight configuration.

2023-10-08 Sun: (2h) Research, analysis and discussion on model size, distribution mode, hybrid deployment, performance trade off, edge device benchmark, and real-time factors; Research on Whisper streaming workaround; Analysis of performance and practicality of wav2vec2.

2023-10-06 Fri: (1h) Voice cloning and synthesis experimentation, note review; Revisiting Huggingface experiments.

2023-10-05 Thu: (3.5h) Research on Whisper, paper and notes, performance data in practice, and related speech recognition development; Research on vector database; Kibana reconfiguration on payment analytics; x.country expiration issue, manual, renewal and general .country maintainer permission update.

2023-10-04 Wed: (2.5h) Discussion and analysis on voice product, tech stacks, and use cases; Task planning and work allocation; Speech model performance review; Research on Twilio voice streaming.

2023-10-03 Tue: (5h) Personalized task planning; Huggingface models and spaces experimentation (tortoise, coqui, others) ; Ad-hoc performance and latency measurements; Domain renewal and functionality technical discussions; ES payment statistics code review and discussions; Discussions on voice related hugginface AI models, benchmark, and possible tasks; GCP Vertex AI permission settings and service account; Experiment with commercial XTTS and TTS models.

2023-09-29 Fri: (6h) Bug fixes on trasient bot state for analytics; End-to-end testing; Research and experiments on state of the art speech related models, performance metrics, pratical experience, and use cases; Analysis and discussion on Whatsapp business platform and bot feasibility.

2023-09-28 Thu: (4h) Fix time measurement issues, type issues, and compile issues with the bot; Kibana dashboard update, raw log view setup, and version rolling; Testing end-to-end and data analytics; Review analytics data; Review context and session constructions in grammY; Move request-based transient data to appropriate places Fix issues with negative time measurement for good.

2023-09-27 Wed: (4h) Discussions on bot, voice AI products, technical limitations, and use cases.

2023-09-26 Tue: (1h) Research on voice AI state of the art demos and improvements (tortoise, coqui, bark, fastspeech, naturalspeech, promptts, and others).
