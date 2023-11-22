2023-11-22 Wed: [Improved](https://github.com/harmony-one/x/pull/245) "Pres & Hold" button handling (fixed lags on spam). [Removed](https://github.com/harmony-one/x/pull/246) all buttons long press amd added "More Action" button. Working on improving buttons handling on "many buttons press case".

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
