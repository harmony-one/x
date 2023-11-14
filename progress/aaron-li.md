2023-11-13 Mon (3h): Technical interview and post-interview analysis; Implementing and testing in-app purchase for GPT-4 booster; Review #167, #168, #169, 170, #171, #173, #174, #175

---

2023-11-12 Sun (0.5h): Review app payment server and API design and discussions

2023-11-11 Sat (6h): Implement basic key protection in relay with AES encryption, multi-key rotation, device id and ip tracking, ban list, and key retrieval API with rate limit; Implement client side decryption and initialization; Client side bug fixes, end-to-end testing; Deployment on GCP and systemd service with instance metadata as parameter; Setup and build guide; Allow local key override

2023-11-10 Fri (1.5h): Review #141, #157, #159, #160; Research on GPT chat session, context compression and effects; Interview preparation and discussion on technical problems 

2023-11-09 Thu (5h): Review #144, #145, #146, #148, #149, #150, #151, #152; Implement QPM limit on streaming services, and rate-limit error handling; Test end-to-end; Research and analysis on iOS market shares by versions, and minimally required versions for key features; Code refactor and applying universal formatting; Implement GPT model switch based on GPT usage time; Implement random alert to share and review based on app usage time; Test end-to-end and fix bugs

2023-11-08 Wed (4h): Review #138, #139; Testing for bugs in complex audio conditions; Update production checklist; Review language requirement, support channel integration, built-in analytics; Review and discussion on checklist suggestions; Technical interview preparation; Extend production checklist with audio bugs, UI bugs, and customer support features; Cleanup and backup Notion data; Fix issues on mail aliases services, implemented pagination; Update checklist on version control issues; Review deep links into settings;

2023-11-07 Tue (2.5h): Make initial production checklist; Research on app analytic systems and integration complexity; End-to-end testing of the app; Fix SSL issue and document steps for future incident resolution; Fix Tweet embedding issues, CSS issues for notion embedding, and research on tweet libraries.

2023-11-06 Mon (2h): Review #114, #115, #117 update, #118, #119, #120, #121, #123, #125; Review OpenAI new offerings and ways of integrations.

2023-11-03 Fri (0.5h): Review #117; New domain and DNS configuration; Review Linux ML development portability to iOS.

2023-11-02 Thu (1h): DNS configurations for lend and Cloudflare issue diagnosis; Lend legal term review; Discussions with security vendors on manual review of swap; Review on-device models and compatibility with iOS devices.

2023-11-01 Wed (4.5h): Fix "Repeat" button's queueing issue; Fix "New Session"; Fix speak button press and release logics; Experiment with shorter word utterance; Fix EAS rate limiting and maintainer issues on x.country and implement caching; Review recent updates (#108, #105, #104, #101, #99) and resolve merge conflicts; Fix "Pause / Play" button bug where the button is sometimes ineffective.

2023-10-31 Tue (2.5h): Reimplement for press-to-talk mode, end-to-end debugging and testing; Further research and actions on phishing warning resolutions; Review #93, #95, #97; Fix bugs and crashes related interrupting OpenAI queries; Discussions on present user experience issues and bugs; (Continued) and discussions on on-device work TODOs.

2023-10-30 Mon (5.5h): Review code updates and errors related to OpenAI streaming (#82, #83, #88, #87, #86, #84, 81); Fix OpenAI streaming implementation and integrations, graceful error handling, crash issues in classic Speech Recognition crash issues, various button failures and unexpected responses; End-to-end debugging and testing, and publishing new deployment in Hey Sam; Discuss findings and tasks related to key protection and attestation; Live discussions related to OpenAI streaming issues.

2023-10-29 Sun (1h): Code review and discussions on alternative OpenAI and Deepgram streaming implementations, recent pull requests and versions, product updates;

2023-10-27 Fri (4.5h+): Deploy and setup relay server instance with domain and certificates; Implement certificate chain verification and binary to PEM conversion; Revise and fix bugs on attestation verification; Implement client side examples for using Relay with TODOs;

2023-10-26 Thu (6.5h): Documenting, testing implementation and TODOs; Implementation of Relay and integration with attestation verification; Code review on recent PRs #70, #73; Review attestation formats, WebAuthn libraries, research on DER encoding, Octet string, ASN.1 sequence, and the maximal use of jsrsasign library; Revise attestation verification implementaiton on missing steps (nonce verification, certificate chain); Research on X.509 custom extension field retrieval, jsrsasign library inner working and utility functions, and past issues and solutions

2023-10-25 Wed (5.5h): Research on OpenAI key generation process, security recommendations; Research on Apple app attestation and integrity services, verification algorithm and reference implementations; Research on CBOR and WebAuthn standards and related libraries, and app attestation design and format; Step by step implementation of attestation verification; Verify reference implementation on public key construction

2023-10-24 Tue (9h): Fix issues with streaming ASR error handling, payload parsing, keep-alive, auto-resuming, and closing; Implementing OpenAI streaming response handling, piping ASR to OpenAI, streamed toke nresponse processing; Piping to Speech synthesizer for end-to-end demo; UI Button integration and implementation based on streamed components; Debugging, end-to-end testing of streaming ASR (Deepgram) + LM (OpenAI); Debugging capturing activation for AVCaptureSession and implementing workarounds; Implement basic measures to counter self-interference (pause listening while speaking), fine-tune parameters and sentence delimiting to compare model performance, deploy to TestFlight; Review PlayHT streaming implementation, documentations, models and styles; Resolve merge conflicts; Implement TTS streaming skeleton; Review latest code commits, package dependency sizes; PlayHT basic partial integration, with TODO instructions; Evalaute and experiment with PlayHT models and parameters

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
