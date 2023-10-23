2023-10-16 Mon: 
Started working on full IOS end-to-end demo "Emotion Build" (using Whipser, GPT4, and Elevenlabs). Reviewed Hey Julia project sources. [Added](https://github.com/harmony-one/x/tree/ios-emotion-build/mobile/samantha) project structure.
 
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
