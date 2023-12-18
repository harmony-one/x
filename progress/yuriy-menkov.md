2023-12-18 Mon: [Added](https://github.com/harmony-one/x/pull/399) twitter lists manage feature, which allowed to configure sources via API endpoints (Any user with API key will be able to add / remove / update twitter list in x-api-backend). Started exploring the possibilities of deploying [evm.ink](https://evm.ink/) to Harmony.

---

2023-12-15 Fri: [Implemented](https://github.com/harmony-one/x/pull/391) "Talk to Me" reading data, loaded from backend. Continue working on "twitter-backend" features.

2023-12-14 Thu: Working with Artem on twitter-api backend. [Added](https://github.com/harmony-one/x/commit/5255a1a70c835ec6454d5bcfac16ca0cb59429b5) table, module and controller to store and manage twitter lists. Next it will be used to load tweets for each list.

2023-12-13 Wed: The tutorial for [deploying Harmony Bridge Tokens](https://delirious-crepe-4c3.notion.site/Add-Bridge-support-for-ERC20-dde13f7f64bf44af9aa93f2dfa2e35ba) and [adding new chains](https://delirious-crepe-4c3.notion.site/Add-Bridge-support-for-new-chain-5748fc212a6d4909b64bf2d26802f2e6) has been completed. [Fixed](https://github.com/harmony-one/layerzero-bridge.appengine/commit/f3cdf2ee6a6460ed7fdfa3ef655ff58917054cc6) an issue with displaying "total locked" tokens. Did a live session with Sun during which we added Linea USDT support to Harmony bridge

2023-12-12 Tue: Added Linea chain and Linea usdc token support to harmony bridge: deployed contracts and update configs ([1](https://github.com/harmony-one/layerzero-bridge.frontend/commit/abedb14b9e73ae9d124ca04e66eda06b8fa4cdb3), [2](https://github.com/harmony-one/layerzero-bridge.frontend/commit/5cf0389d0b0ea8febe943857d8ba3e12a76b6620), [3](https://github.com/harmony-one/layerzero-bridge.appengine/commit/f3e71e016973f273fba57f50afd7b1d81d1474aa), [4](https://github.com/harmony-one/layerzero-bridge.appengine/commit/04ca61f993411644d8e9d69e73dac15bba0bbae6)]). Debugged issues, synced with layer zero team to enable linea<->harmony bridging.

2023-12-11 Mon: [Refactored](https://github.com/harmony-one/layerzero-bridge.frontend/pull/20) layerzero bridge frontend & [backend](https://github.com/harmony-one/layerzero-bridge.appengine/commit/a296a8a9b317d58b9d1d405b1db9273cd457b8c1) to do deployment steps more simple. Preparing a training manual.
 
---

2023-12-8 Fri: [Splited](https://github.com/harmony-one/x/pull/329/commits/e303d086f8a4ec664af950a2060ca59b0eb64574) the benchmarks measurement into 5 steps. The steps are done according to Aaron's [instructions](https://github.com/harmony-one/x/blob/main/doc/benchmarking.md). [Extended](https://github.com/harmony-one/x/pull/329/commits/a26e4d960bc23c61bf67025da75a83c140ec6a6a) relay to support more fields.

2023-12-7 Thu: [Added](https://github.com/harmony-one/x/pull/329) benchmarks for "text to speach" and "speach to text" steps. [Extended](https://github.com/harmony-one/x/pull/329/commits/b7331f0bbea63337b3fd0f5a11fa4efbb94a76fc) relay service to support stt, tts metrics. Continue working on kibana manage to display table with all benchmark stats.

2023-12-6 Wed: Tested [build](https://github.com/harmony-one/x/commit/63fa70f6c4118d7bf5fe66cc2a80f2b9d9c83513) with DeepgaramASR to speed up record start. Working on benchmarks with Kibana.

2023-12-5 Tue: Looking for a solution for microphone handling, specifically to resolve the issue where the first word often cuts off. 

2023-12-4 Mon: [Fixed](https://github.com/harmony-one/x/pull/300) build errors for VoiceAi_2 app. [Added](https://github.com/harmony-one/x/commit/8cfd889d3c760d61aa65843110e9a3f91b68ae9e) more tests for CustomInstructionsHandler. Working on benchmark.

---

2023-12-1 Fri: [Added](https://github.com/harmony-one/x/pull/296) elastic client to collect the stats for elasticsearch and next analyze the request time result in kibana. Working with Segey on resolving "Press and Hold" bug.

2023-11-30 Thu: Inspected different ways to collect benchmarks for open ai requests with different network speed. [Added](https://github.com/harmony-one/x/pull/290) sentry perfomance monitoring example. Working on TimeLogger extension to collect the stats for elasticsearch and next analyze the result in kibana.

2023-11-29 Wed: Working on OpenAI Stream benchmark tests for poor network [tests draft](https://github.com/harmony-one/x/pull/284). Continue working on [AppleSignInManager](https://github.com/harmony-one/x/pull/279) tests.

2023-11-28 Tue: Worked on unit tests for [TimeLogger](https://github.com/harmony-one/x/commit/3ae423546370fef7e8a703709a0a6e73e033e1c7), [AppleSignInManager](https://github.com/harmony-one/x/pull/279) and [SettingsView](https://github.com/harmony-one/x/commit/57423c36bd32ad664c846dacb4c6f7b9823fe9c8) modules. [Added](https://github.com/harmony-one/x/pull/277) refacoring optimisations.

2023-11-27 Mon: [Added](https://github.com/harmony-one/x/pull/269) buttons unit tests: GridButton, PressEffectButtonStyle, Theme. Resolving conflicts nad continue refacoring ActionsView [module](https://github.com/harmony-one/x/pull/259) to decrease cyclomatic complexity.

---

2023-11-24 Fri: [Resolved](https://github.com/harmony-one/x/pull/249) conflicts. [Resolved](https://github.com/harmony-one/x/pull/258) Cancel "Tap to speak" record on press any other button. Fixed eslint errors and build issues. [Refactored](https://github.com/harmony-one/x/pull/259) ActionsView to decrease cyclomatic complexity.

2023-11-23 Thu: [Fixed](https://github.com/harmony-one/x/pull/249) problems when pressing multiple buttons at the same time (now you can't use "Tap to speak" and "Press and hold" at the same time).

2023-11-22 Wed: [Improved](https://github.com/harmony-one/x/pull/245) "Pres & Hold" button handling (fixed lags on spam). [Removed](https://github.com/harmony-one/x/pull/246) long press handling from all buttons; Added "More Action" button. Working on improving buttons handling on "many buttons press case".

2023-11-21 Tue: [Fixed](https://github.com/harmony-one/x/pull/237) "Tap to Speak" issues: changed to "Tap to Speak" instead of "Tap to SPEAK", fixed colors blink on spam, fixed button delay and lags on spam. [Increased](https://github.com/harmony-one/x/pull/239) openAI rate limits. Continue working on tests.

2023-11-20 Mon: [Added](https://github.com/harmony-one/x/pull/231/files) unit tests for: ThemeManager, NetworkManager, AppleSignInManager modules. Updated NetworkManager module to improve test coverage; Added mocks for emulation network response.

---

2023-11-17 Fri: [Configured](https://github.com/harmony-one/x/pull/211) "Voice 2" build for internal testing. Сontinue work on unit tests for stream modules and ui buttons.

2023-11-16 Thu: [Resolved](https://github.com/harmony-one/x/pull/197) bugs regarding long press triggering tap functionality (when pressing long, unnecessary actions were triggered). Investigating the possibility of eliminate mic initialization lag when using "Press & Hold".

2023-11-15 Wed: [Implemented](https://github.com/harmony-one/x/pull/189) button debounce after 10 taps to prevent crashes, also fixed pause/play lag. [Added](https://github.com/harmony-one/x/pull/192) UI tests for new cases. Working on delay correction long press triggers in App purchase.

2023-11-14 Tue: Working on setup more comprehensive/granular sentry logs. Helped Nagesh with setup/test [branch](https://github.com/harmony-one/x/pull/182) (uploads dsym file). [Added](https://github.com/harmony-one/x/pull/183) swiftlint tool to enforce Swift style and conventions. Fixed project sources lint styles.

2023-11-13 Mon: Working on setup buttons [debounce](https://github.com/harmony-one/x/pull/170/files) to have better app stability (prevent crashes etc). Working on setup more comprehensive/granular logs (sentry)

---

2023-11-10 Fri: [Resolved](https://github.com/harmony-one/x/pull/161) issue with long press actions (Ensure long press actions do not trigger tap actions vice versa). Working on tracking active using app time and showing suggestions to share with friends and share on Twitter.

2023-11-9 Thu: [Added](https://github.com/harmony-one/x/pull/148/files) the ability to repeat the current session to resolve repeat bug (When hitting "Repeat" during the first stream, it says "Hey" while the stream is going. It should just start again from the beginning instead.) 

2023-11-8 Wed: Continue working on [error capturing](https://github.com/harmony-one/x/pull/136) based on Aaron's [checklist](https://github.com/harmony-one/x/blob/main/doc/checklist.md). Added action buttons metrics based on sentry ui metrics.

2023-11-7 Tue: [Working](https://github.com/harmony-one/x/pull/136) on logging an iOS application using sentry.io as a platform for storing and viewing logs

2023-11-6 Mon: Working on reolving "speaker popping" issue (reproduced on quickly pause/play switch and new sessioan start). Bridge tasks support (btc tranquil payments).

---

2023-11-3 Fri: Working on build and review unit tests for voice ai. Updated staking dashboard ui. bridge tickets support.

2023-11-2 Thu: Working on different UI fixes: beep signal on released speak button, speak and pause bottons color changing sync, pause button blinks. Continue working on unit tests update. 

2023-11-1 Wed: Working on UI fixes for Press to Speak button (colors, stuck). Unit tests for GPT Streaming module (in progress). Support for staking dashboard with mainnet shard reduction from 4 to 2.

2023-10-31 Tue: [Added](https://github.com/harmony-one/x/pull/94) ChatGPTSwift lib for better gpt streaming stability / resolving bugs. Working on unit tests for Streaming module and UI components.

2023-10-30 Mon: (Resolve bugs in GPT streaming PR, specifically button interaction and async request/response handling) Continue working on GPT streaming [PR](https://github.com/harmony-one/x/pull/84)

---

2023-10-27 Fri: [Added](https://github.com/harmony-one/x/pull/80/files) deepgram streaming to main app. Working on button integration with streaming workflow.

2023-10-26 Thu: Reviewed Aaron's streaming code pr's. [Copied](https://github.com/harmony-one/x/pull/72) streaming core sources to ios-yuriy for next whishper integration. Continue working on bugs from kanban board.

2023-10-25 Wed: Working on bug fixes for Voice AI app: the "Speak" button becomes non-functional while ChatGPT is processing, and the "Pause" button loses its functionality while the response is being processed.    

2023-10-24 Tue: Continue working on full IOS end-to-end demo using Whipser, GPT4, and Elevenlabs: setup build and starting integrate Whipser speach to text via rest api.

2023-10-23 Mon: Started working on full IOS end-to-end demo "Emotion Build" (using Whipser, GPT4, and Elevenlabs). Reviewed Hey Julia project sources. [Added](https://github.com/harmony-one/x/tree/ios-emotion-build/mobile/samantha) project structure.
 
---

2023-10-20 Fri: Added more text to speech integrations to willow demo: [Google Cloud](https://github.com/harmony-one/x/pull/44), [Microsoft Azure](https://github.com/harmony-one/x/pull/50). [Added](https://github.com/harmony-one/x/pull/48) select dropdown for speach to text to willow demo. Started setting up play.ht

2023-10-19 Thu: [Added](https://github.com/harmony-one/x/pull/44) STT Deepgram streaming widget for wis demo. Working on table to see historical latency data to compare.

2023-10-18 Wed: 
Started work on Emotion build. [Added](https://github.com/harmony-one/x/pull/39) TTS Core select (Elevenlabs + Willow microsoft model) for WIS end to end [demo](https://yuriy.x.country/). [Added](https://github.com/harmony-one/x/pull/41) more metrics (stt + llm + tts).

2023-10-17 Tue: 
Completed WIS end to end [demo](https://yuriy.x.country/) Working on streaming for WIS STT.

2023-10-16 Mon: 
[Working](https://github.com/harmony-one/x/pull/27) on full end-to-end gui for Willow based on Willow [rest api](https://54.186.221.210:19000/api/docs#/)

---

2023-10-13 Fri:
[Willow demo draft](https://github.com/harmony-one/x/pull/17) Added willow demo draft. webrtc stt working, continue working on other functions (tts, sts, speaker change). [Resemble AI demo](https://github.com/harmony-one/x/pull/19)

2023-10-12 Thu:
[Added](https://github.com/harmony-one/x/pull/10) the gdansk-ai repository, worked on deployment and setting up the environment. Started diving into api/docs for Willow inference server - for the next creation of a webapp demo.

2023-10-11 Wed: [1 part](https://github.com/harmony-one/x/pull/7) [2 part](https://github.com/harmony-one/x/pull/8) - Added storing/displaying of gpt chat history + updated UI; [Refactoring](https://github.com/harmony-one/x/pull/6) - Added Mobx state manager, update layout; Working on store/display metrics for (stt-gpt-tts) (eta - today)

2023-10-10 Tue: [Completed](https://github.com/harmony-one/x/pull/4) - Added tts audio player, integrated with elevenlabs (rest) and gpt streams, integrated with Artem's PR's. Code refactoring. Started work on UI improvements.

2023-10-09 Mon: I tried different options for working with TTS Elevenlabs (rest, ws), tried different sentence breakdowns. At the moment, we managed to achieve requests of 1.3 seconds for each sentences from the chatgpt stream. Also the current tts engine has many problems and often audio tracks overlap each other - a player is needed to manage them. Then i started working on the adding the tts audio player to project (smart management of audio chunks), and its integration with the chatgpt and elevenlabs stream [Worked](https://github.com/harmony-one/x/pull/4)
