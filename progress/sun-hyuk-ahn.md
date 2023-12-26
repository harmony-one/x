2023-12-29 Fri: Paid time off.

---

2023-12-29 Fri: Write from scratch a minimal bridge to/from arbitrium in 500 lines on command line.

---

2023-12-20 Wed: Deployed mint.i.country.

2023-12-19 Tue: Started development for minting tools and indexer required for the inscription tokens.

2023-12-18 Mon: Research into inscription tokens.

---

2023-12-15 Fri: Replaced random facts with the talk to me logic. Set token limits for the context. Currently, looking at a bug that stops the synthesis for Talk to Me (hand over to Yuriy).

2023-12-14 Thu: [Completed](https://github.com/harmony-one/x/commit/8002e4631c372d5f9520fcc386b1079deb5159c2) the updated implementation for the hardcoded news feed, which is fully merged and working with the following sources (soccer, appl, btc, eth, one). Started working on the backend implementation to fetch data from sources based on this [doc](https://github.com/harmony-one/x/blob/main/doc/follows) (hand over to Artem).

2023-12-13 Wed: Completed and refactored logic for fetching from data feed and providing to OpenAI context. Wrote tests for coverage for the DataFeed file. Deployed USDT on the Linea <-> Harmony bridge. 

2023-12-12 Tue: [Implemented](https://github.com/harmony-one/x/pull/370) end-to-end logic for "Talk to ME!" news feed fetching and user profile settings.

---

2023-12-10 Sun: Configured a.country.  

2023-12-09 Sat: Discussed Twitter implementation with Aaron. Will meet up with Yuriy and Artem on Monday.

2023-12-08 Fri: Updated transcript logic handling. There is a known bug in Testflight and Production where some data is transcribed as "private", need to enable the information.

2023-12-07 Thu: Updated speech recognition logic handling to prevent "No Speech Recongition" error (as well as minor "errors") from being reported. Refactored TimeLogger logic measuringa app performance.

2023-12-06 Wed: Implemented enhanced transcription functionality of obtaining [setting information](https://github.com/harmony-one/x/pull/319/commits/32532bec445284f2b9f4d68093873d4f4d03e950) (model identifier, app version, and ios version) and [limiting](https://github.com/harmony-one/x/pull/319/commits/b55eaecd99a866f24903d09f2a0d9da840411c96) the size of transcript to 10MB. Artem will be finishing up the remaining tasks regarding the enchanced transcription. Updated font alignments and icons for the "Pause / Play" to match all other icons.

2023-12-05 Tue: Discussed and assigned tasks, as well as their ETAs to engineers with Theo F. Fixed a bug that threw nil pointer when transcription was empty. Began setting up haptic feedback for "Press & Hold" (handoff to Nagesh).

2023-12-04 Mon: Out of office

---

2023-11-29 Fri - 2023-12-03 Sun: Out of office

2023-11-28 Thu: Fixed user deletion and creation flow bug. Updated context length from 500 to 8000. Updated setting fields to have matching format.

2023-11-27 Wed: Fixed Network manager handling bug. Refactor and cleanup in app purchase process. In app purchase server side bug fix (hand off to Artem).

2023-11-26 Tue: Benchmarked latencies for head vs subsequent, which came out to 1.6s vs 1.3s (1hr session). The cause is due to the initial setup on the client (audio buffers and sockets) and server-side (authorization). Fixed expiration update [bug](https://github.com/harmony-one/x/commit/51c175aaa66b0e460e555d39972b74db1254732a).

2023-11-25 Mon: Fixed color switch bug on a new context. Implemented perceived latency on the client side. Measured latency to be an average of 1.4 seconds. Testing different chunking sizes to improve latency. 

---

2023-11-24 Sun: Going over PRs 261-266. Will be testing them tomorrow and merging them in order.

2023-11-25 Sat: Worked on resolving the linter issue.

2023-11-22 Wed: Fixed "More Action" button [bug](https://github.com/harmony-one/x/commit/d71ba3566c76794378b3492281dab13be132f7c8) and updated the icon. Fixed a [bug](https://github.com/harmony-one/x/commit/9fcde16412d557e0e910a5c081353f46125facd8) that rate-limited users upon new context.

2023-11-21 Tue: Updated asset structure so that they are shareable across different builds. Fixed asset [alignment and sizing](https://github.com/harmony-one/x/commit/fb6fcae7b780ff245abec55cb8b05516091059d4). Refactored [AppConfiguration](https://github.com/harmony-one/x/pull/242) module.

2023-11-20 Mon: Finalized the attestation issue (since we were requesting one from the App Store each time, some users were rate-limited) and solved it using caching from the relayer server. Measured the new perceived [latency](https://imgur.com/a/ExTJbIt) using a proxy server, which is around ~900ms median with up to ~1500ms as max.

---

2023-11-19 Sun: Refactored [OpenAI](https://github.com/harmony-one/x/commit/ef517118beaaa57bdbe9ede53b37072e47f519b5) and [Actions](https://github.com/harmony-one/x/commit/8f7220effd080dbcf01fb73933b302c053f4e4dd) module.

2023-11-18 Sat: Reviewed over updates made for the [relayer](https://github.com/harmony-one/x/tree/main/voice/relay).

2023-11-17 Fri: Resolved relayer issue.

2023-11-16 Thu: Resolved issue with retry API not being canceled. Updated product configuration and improved logic handling to prevent crashes when required data is not provided. Worked on the restore server logic handling to be in accordance with the voice app's new product configuration. 

2023-11-15 Wed: Discussing key auth server infrastructure with Aaron. Fixed custom instruction configuration so that it loads when the app is downloaded and first loaded. Disabled Apple Pay and user authentication. Addressed and fixed (handed over) a bug that crashed the app when user authentication is loaded.

2023-11-14 Tue: Updated chunking size (10 / 50) with exponential backoff of a total 10 min and canned response. Worked with Frank on implementing custom instructions, as well as setting configurations. Fixed voice selection bug. Went over OpenAI's Assistant to see a better implementation of context embedding without having to provide it each time. The current limitation of "assistant" is that streaming is not supported.

2023-11-13 Mon: Fixed a bug that ensures custom instructions are not deleted when cleaning up context for 512 max tokens. User testing with Theo and Alaina to diagnose if there are persistent issues with the current chunking method. Went through the official OpenAI API documentation, as well as various sources to see if there was an optimal way of implementing context embedding rather than providing it every time (result: there does not exist one as of now; Artem / Aaron going over other implementations)

---

2023-11-12 Sun: Reviewed Aaron's PR on the relayer service, as well as the configuration in the cloud service.

2023-11-11 Sat: Configured [Github action and Husky pre-commit hook](https://github.com/harmony-one/x/pull/165) preventing AppConfig.plist from being committed.

2023-11-10 Fri: Debugged time calculation logic that triggers gpt-3.5.

2023-11-09 Thu: Implementing long-press actions for multiple buttons. Fixing various bugs for the launch day. Debugging Aaron's rate limit merge (initially defaulted to 3.5turbo due to date calculation bug).

2023-11-08 Wed: Implemented "Press to Speak & Press to Send" button. Researched different tools we can use to develop the "share" feature. [Branch](https://www.branch.io/) seems to be the most useful SDK. Began looking into the SDK to start implementation.

2023-11-07 Tue: Update streaming to initially flush 5 words then by delimiting punctuations, upperbounded by 20 words. Finished setting up Sentry with Yuriy. Exponential backoff changes to 2, 4, 8 seconds.

2023-11-06 Mon: Fixed a bug that ensures streams that are part of the previous word are appended correctly. Upper bounded buffer to contain 10 words at max so that synthesis occurs at delimiter or 10 words. Implemented retryable methods with exponential backoff.

---

2023-11-06 Sun: Fixed existing conflicts for some PRs and have reviewed/merged them. Began refactoring the code to make it production-ready.

2023-11-04 Sat: Made updates and benchmarked the updated streaming implementation. Observed that the initial stream takes about 2-3 seconds but the latter ones are ~950ms.

2023-11-03 Fri: Updated Random Fact button to return random entries. Discussed with Aaron and Julia different approaches to improving the latency. Introduced initial flush (thinking -> synthesizer) of x (currently 5 words) words that increase the perceived latency.

2023-11-02 Thu: Fixed repeat button bug. Previously, it was only repeating the final streamed portion. Now it repeats the whole response. Demoed Voice AI at the Voice AI meetup.

2023-11-01 Wed: Fixed streaming interruption bug. Fixed the Press to Speak button functionality and color change bug. Discussed major persisting bugs and handed them over to the remote engineers.

2023-10-31 Tue: Spent time debugging a bug crashing the app during the "Press to Speak" interruption. Realized that when the streaming is completed, during synthesis, interruption is being handled correctly. However, while streaming, starting a new recognition will crash the application. Fixed bugs preventing Pause / Play button from working.

2023-10-30 Mon: Fixed bugs preventing ChatGPT streaming from working. Fixed another bug preventing interruption during synthesis.

---

2023-10-29 Sun: Cleaning up Yuriy's PR so that the "Press to Speak" button is working. Will wrap up tomorrow.

2023-10-28 Sat: Reviewed Yuriy's PR on streaming implementation for OpenAI.

2023-10-27 Fri: Fixed "Press to Speak" so that it does not crash from silence anymore. Bug fix regarding interruption has been fixed, "Press to Speak" in the middle of generation and synthesis is working as expected. There is a known bug where a user rapidly spamming "Press to Speak" button will the audio functionality to crash (will continue working on this). ChatGPT4 context has been enabled.

2023-10-26 Thu: Redeployed with another bug fix where "Press to Speak" button ends only when user lets go of the hold (previously 1.5 second silence would stop the recording). Implemented interruptibility where recognition task and audio response now stops when user holds the "Press to Speak" button, starting a new recognition task. Implemented OpenAI call with custom instruction embedded.


2023-10-25 Wed: Fixed another bug preventing "Press to Speak" button from working. Fixed the bug and refactored code so that any layout and / or design change will be separated from the logic implementation. Began implementing OpenAI streaming functionality based on Aaron's build.

2023-10-24 Tue: Fixed a bug preventing "Press Speak" button on the press build from working. Deployed the fix on "Voice AI" and "Sun". Began polishing the repo so that it is production ready. Will implement CI/CD pipeline, add linting rules, and other components that will make the repo more robust.

2023-10-23 Mon: Wrapped up user perceived latency for web app which is 15%, 45%, and 40% for transcription, knowledge base, and synthesis respectively (Deepgram, GPT4, and Azure / Google). I also deployed "sun" as a fork of FissionLab's Voice AI. There are many bugs to fix, mainly "Speak" button not working, and I will continue on fixing the bugs with Julia tomorrow. I have also set up another machine for Ivan to test out multiple LLM models.

---

2023-10-22 Sun: Measured latencies for Google. Can test out the latencies [here](https://yuriy.x.country/). Continued studying xcode to participate in iOS development and measure latencies.

2023-10-19 Thu: Continued working on calculating individual latencies for the API to use. Tested Azure, Google, and began to a look at Play.ht.

2023-10-18 Wed: Calculated end to end and user perceived latencies for sam.x.country. This [document](https://www.notion.so/harmonyone/API-Percentage-b44ce9c347f5474fb0f0a36c02dc6e55?pvs=4) contains detailed information. Started learning Xcode in order to benchmark and make improvements to ths X iOS application.

2023-10-17 Tue: Benchmarked latencies for various speech to text API. Deepgram [outperforms](https://www.notion.so/harmonyone/API-Benchmark-f3bee005a3aa4e4eb302ad02647a3d8b?pvs=4) others by far. Fixed ElevenLabs issue "webapp" was having. Had a meeting with Ivan to prioritize tasks, we will work on benchmarking latency percentage for the end-to-end flow.

2023-10-16 Mon: Updated the app to support iOS compatibility on Safari, which will become the main browser for /sam. Began setting up Prometheus to measure time lapsed on key components of the app (DeepGram, ChatGPT, and ElevenLabs).

---

2023-10-13 Fri: Deployed voice-webapp on [sun.x.country](sun.x.country). Working on integrating with Ivan's Acapela to the voice-webapp. Looking for various areas of optimization.

2023-10-12 Thu: Studying and going over Hugging Face [Quantization](https://huggingface.co/docs/transformers/main_classes/quantization); Wrestling [GPTQ](https://arxiv.org/pdf/2210.17323.pdf) paper (still need time to fully digest the material); Building demo 8-bit GTPQ (referenced from this [repo](https://github.com/IST-DASLab/gptq)); will continue working on this tomorrow

2023-10-11 Wed: Set up access and permission to supercomputing infrastructure with GPUs (for Ivan); Set up access and permission to Picovoice Rhino benchmark testing; Benchmarked the following NLU models: Picovoice Rhino, Google Dialogflow, Amazon Lex; Picovoice Rhino outperforms the other mentioned models by ~30% average
