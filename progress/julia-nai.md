2023-12-13 Wed: Opened PR to [whitelist](https://github.com/harmony-one/swap-token-list/pull/2) lUSDC and [for](https://github.com/harmony-one/swap-token-list/pull/3) lUSDT. Tested opening a ONE/lUSDC pool on swap. Waiting for Ethereum to Linea bridge to open larger pool on swap. [Created](https://github.com/harmony-one/x/issues/382)/[investigated](https://github.com/harmony-one/x/commit/51436e3107e0b7faafe1c814965968c0bedf40e3) issue #382 on pausePlayBug branch.

2023-12-12 Tue: [Optimized](https://github.com/harmony-one/x/pull/363) microphone latency by removing debouncer on press & hold button. Pushed [fix](https://github.com/harmony-one/x/issues/364) for issue #364 to synchronously handle Press & Hold interrupting playback. Added haptics logging to transcript to attempt to diagnose issue #345.

2023-12-11 Mon: [Added](https://github.com/harmony-one/x/commit/104db3f7f393ef50970fd96d5362095c40f145e2) haptics and increased button timeout of trivia gesture. [Hotfixed](https://github.com/harmony-one/x/commit/614ebbcfdea3f8380b37804fc5b012d089e952cd) surprise me button long press disabling other buttons. [Fine-tuned](https://github.com/harmony-one/x/commit/bb3578fd57c198b60519bb910767ca9f57099372) response. [Adjusted](https://github.com/harmony-one/x/commit/27b2849ab6d38f33569ee7cfa345c856b815d08c) queries to directly use preferredLocal; evaluating the need to keep Languages.swift. Validated dialect support\* with Cantonese. [Fixed](https://github.com/harmony-one/x/commit/296fde859f85e3b4fe13ad5f4b911edd73cca311) and added more [fixes](https://github.com/harmony-one/x/commit/8a62bfb74d11781319cd3663e802a4d43305eca9) for \<private\> transcript issue (waiting to see if fix works for testflight/appstore). 

\* Because of Apple's language code handling, system language set to `Cantonese, Traditional 繁體廣東話` does not work with the app— transcription fails. However, system language set to `Chinese, Traditional (Hong Kong) 繁體中文（香港)` does work with the app.

---

2023-12-10 Sun: [Created](https://github.com/harmony-one/x/commit/6941361763852c94919c1f3e3517b8140b69fd49) framework for analytics docs. [Added](https://github.com/harmony-one/x/commit/355f7e742277ecc748774113274bde54afa92518) trivia as long press on Surprise Me button.

2023-12-09 Sat: Time moved to Sunday.

2023-12-08 Fri: Pulled Voice 2 metrics for usage and total sessions. Researched Google Gemini API, confirmed API availability on Dec 13. Filmed text based RPG demo video (need to edit over the weekend). Demoed Whisper trivia to Theo F.

2023-12-07 Thu: Debugging tests suite not running. [Created](https://github.com/harmony-one/x/commit/eb6758a48f1f8047e3bb4b5a420419ba78207949) collection script for data from Elasticsearch and Sentry. [Fixed](https://github.com/harmony-one/x/commit/475032959171946201ae9abf3e7d69f6914a292d) the error counter and verified against Sentry dashboard. Assisted Alaina in setting up and running collection scripts. [Created](https://github.com/harmony-one/x/commit/cdeeb88b8863b31018b0a8189f4e5db02f51e689) basic beginner guide readme for collection scripts. 

2023-12-06 Wed: [Created](https://github.com/harmony-one/x/commit/17e6e0f27a5b13cbd31d6311f312cde7484e551d) openAI API stat scraper. [Added](https://github.com/harmony-one/x/commit/d6be2635c595dc09e19fe1662682b565d93b1395) average first and total response times. Helped debug the tests not working. 

2023-12-05 Tue: [Created](https://github.com/harmony-one/x/commit/fe6f76f2e3365e77d210f9265bc40b632544ff8c) and [updated](https://github.com/harmony-one/x/commit/17396077f1c767298d73017e858eff7b4b3ebaa6) test for CreateUser.swift. [Expanded](https://github.com/harmony-one/x/commit/da8686567602b4aebc7b80b68e3e2d5da56e96fe) testing for buttons in ActionViewTests. [Resolved](https://github.com/harmony-one/x/commit/e8f32dd2170059616a65923fbd5911173f7f9b25) some lint issues. 

2023-12-04 Mon: [Add](https://github.com/harmony-one/x/commit/2302110822a940c743f358961eb474deaf8c6595) guard against empty return in RandomFact.swift. [Updated](https://github.com/harmony-one/x/commit/51f16b7eca0e38576fc01b6b8a4d714c01f2a8b0) testGetTitle. [Added](https://github.com/harmony-one/x/commit/970dc6f69b994e043cc6d6828125544c275ddce6) tagging to differentiate Sentry alerts from internal testings vs. live app. Fixed incomplete ArticleManager test and removed test for removed function. 

---

2023-12-03 Sun: Tested and merged [PR#250](https://github.com/harmony-one/x/pull/250) first pass removal of custom instructions from saved transcripts. Finally got API key working on local build. Worked with Rikako to plan getting test coverage to 99%. 

2023-12-02 Sat: There are multiple instances of the custom mode text in the app, so I am working on identifying which are still needed and which are extraneous. Worked on getting local build working again with new API key.

2023-12-01 Fri: Tested the app and identified some issues with custom mode selector. The original implementation of custom instructions through the system seems does not seem to be connected entirely so overriding that with custom modes does not produce the intended results. 

2023-11-30 Thu: [Changed](https://github.com/harmony-one/x/commit/685e963c17facf4cec04549d8bde487e58c97c37) wording and capitalization of action sheet options in line with specifications. Moved account related options to a sub-page of "Purchase premium" option in action sheet. 

2023-11-29 Wed: [Implemented](https://github.com/harmony-one/x/commit/74f2753e7d696440765db255341103a3e7aebbe3) selection of custom modes detailed by Theo P [here](https://harmonyone.notion.site/3-Predefined-Custom-Instructions-b36546c4ee544aea8168c7f046c476c5?pvs=4) as a drop down in the [system settings page](https://github.com/harmony-one/x/commit/0a75eca8eea805767139e8784f45dcaa77aec2c3). The example interactions are added as user/agent. Needs to be tested. 

2023-11-28 Tue: [Wrote](https://github.com/harmony-one/x/commit/c4055e2625f2f0e89f0d2084fb807bfb9509d0a2) a function to test how liveliness check may work. [Created](https://github.com/harmony-one/x/commit/58208f43f42f0e9558a48fb92e25a8e44e903911) framework for custom instructions test. This test will make sure that custom instructions are working by expecting certain outputs given fixed inputs (ex. name is Sam, no "Sorry" etc.). 

2023-11-27 Mon: Researched how to impliment component testing for liveliness check for GPT through app. Began implimenting testing in app.

---

2023-11-26 Sun: Tested app build to see if build issues from Friday were resolved. Ran a small feasability test through ChatGPT whisper. While the responses for debate partner could be good, the lack of recent information does limit the topic. Something like a more esoteric moral debate seems to work. Hallucinations make a fact based debate rather difficult. (In debate terms, a LD or old PF would work best). 

2023-11-25 Sat: Migrated relevant private notes off of Notion pending my removal from Notion editing.

2023-11-24 Fri: [Reviewed](https://github.com/harmony-one/x/pull/250) removal of ChatGPT custom instruction from Nagesh and Aaron. Worked on resolving issues with building. When attempting to run latest build, encountered build failiures as a result of recent changes. 

2023-11-23 Thu: Thanksgiving

2023-11-22 Wed: [Removed](https://github.com/harmony-one/x/commit/bcafb1b131f8c82d066931c0dd486c3d5b2ac6df) the custom instructions from saved transcripts ([#250](https://github.com/harmony-one/x/pull/250)). Began working on liveliness check for GPT component (automated testing of hard coded intput and response). 

2023-11-21 Tue: Worked on removing the white background from action sheet. Worked on saving the conversation transcript from Voice AI to notes.

2023-11-20 Mon: [Updated](https://github.com/harmony-one/x/commit/7efbe822df80d1100b10cbc6218d58b43fb00855) topArticles list to remove some footballers, content with adult themes, and potentially repetitive titles. Total topics reduced from 1182 to 1158. 
[Added](https://github.com/harmony-one/x/commit/bf345dc969fc34fbdc2e43f35e3d2e5ecd50e146) action sheet for long press on Pause/Play button. TODO: remove white background and replace with darkened app screen. [Updated](https://github.com/harmony-one/x/commit/b0c79a60bf77a7bdbe846c8a22c72afe46a700a2) object name. 

---

2023-11-12 Sat - 2023-11-19 Sun: Paid time off.

---

2023-11-10 Fri: Engaged in product testing, investigating the handling of overlap with the tap/hold buttons. When both are activated, the other occasionally does not turn off. This seems to be related to the way stop transcribing is handled. [Assisted](https://github.com/harmony-one/x/commit/73204359eae8079c968d531fd0333591db373642) in reverting code that was causing some compile issues. Triaging issues related to .gitignore. [Merged](https://github.com/harmony-one/x/pull/163) and reviewed #163 Add updates to unit tests.

2023-11-09 Thu: [Created](https://docs.google.com/spreadsheets/d/1IlE0EpLUsmmDPwdx2b6adzw1UGeY3f-o-dO6qbWN0b8/edit?usp=sharing) dynamic pricing calculator spreadsheet for GPT 4 with adjustable assumptions. 
[Reverted](https://github.com/harmony-one/x/commit/0659298ca8caca81ec4c34f26ce3e2fd05a4c897) custom instructions.
Worked on investigating the tap to speak button slowness. I have a local build which dumps extra debugging information in an overly verbose way, but I have not been able to identify the source of the issue yet. 

2023-11-08 Wed:
[Created](https://github.com/harmony-one/x/commit/9f894a4c88da0b87dd56cef53bebd61ebdf91a1b) app to test for optimal synthesis chunking strategies and replicate odd synthesis behavior.
[Implemented](https://github.com/harmony-one/x/commit/d6ec4b9b140decad26b39d5b234a8b6a827e8c30) Theo P’s custom instruction set as default. Now, the user can ask questions about the app and receive guidance on how to use the app. The app says it is created by x.country team and gives some input on what can be done with the app.
[Reviewed](https://github.com/harmony-one/x/pull/143) Rikako’s language implementation. Tested Mandarin, English, Korean, and Spanish with great success.The user can speak in the language that their iPhone is set to and the app will respond in that language. For reasons seemingly related to the way dialects are handled by Apple, Cantonese does not seem to work. The random fact button will still read out in English. 

2023-11-07 Tue: I [started](https://github.com/harmony-one/x/tree/tap-to-send) work on the framework for the Tap to Speak/Tap to Send button. I reviewed Sun's [PR](https://github.com/harmony-one/x/pull/137) and began researching how to implement the missing component "Make the button interruptible." \
Right now, there seems to be some unintended behavior with interruptions. I am reviewing how the stopRecording() function is implemented. To have proper interpretability, I believe I will have to change the way stopRecording is implemented to avoid sending an incomplete query to GPT. 

2023-11-06 Mon: \
[Updated](https://github.com/harmony-one/x/commit/9fc0405b8d205f26b635035b95cb6d8762a78445) Skip button to use LongPressGesture and removed timer. Changed the long press times to default. \
[Hard coded](https://github.com/harmony-one/x/commit/a24e51d763529d81bba6a627931e3394f3efdf6c) 600ish wiki titles and changed the random fact query to summarize a random topic from the array of titles. \
[Increased](https://github.com/harmony-one/x/commit/ad46b0dbe9b0640690d5045c19d9938dc71dabf1) the number of hard coded titles to 1182 from a combination of most views Wiki articles of all time and top 400 wiki articles from 2021 to avoid ChatGPT’s knowledge cutoff. \
[Added](https://github.com/harmony-one/x/commit/2760b2bef0f64552e1e7a91a35c9d5a404037b08) Say More feature: a new button to expand on last topic. This button replaces the Skip button. \
[Began](https://github.com/harmony-one/x/tree/surprise-me) changes to make Random Fact button into Surprise Me button. Currently functional with wikipedia summary, riddles, trivia questions, jokes, inspirational quotes, and fun facts, but there is higher than acceptable repetition in riddles, trivia question, jokes, and inspirational quotes. 

---

2023-11-05 Sun: [Changed](https://github.com/harmony-one/x/commit/bfc50ee2c6c8b9d18c6b23f39debeb20b79a6bfd) the random fact button to summarize a random wikipedia topic from the top wikipedia topics in 2 sentences or less. 

[Added](https://github.com/harmony-one/x/commit/3709ad808179f494cb3bab3d2b380725e5c5bb07) long press on Repeat Last button to open settings and [resolved](https://github.com/harmony-one/x/commit/5f0cf52887a863c8f5967840497c5c80f96e7559) an issue with longer-than-default long presses being inconsistent. When the minimum long press time is changed from default, the long press seems to only work 80% of the time. I believe this is because sometimes, since 3 seconds is very long, the finger moves more than the allowed distance; therefore, it is not registered as a long press. I added a geometry reader to match the maximum distance that your finger can move during the long press to the size of the button.

2023-11-03 Fri: [Implemented](https://github.com/harmony-one/x/commit/67c11ec307580d8b79525326c05a44586408a281) randomness for the random fact button. [Added](https://github.com/harmony-one/x/blob/main/voice/voice-ai/x/SpeechRecognition/SpeechRecognition.swift) a cap to the synthesis buffer. If the response doesn't have punctuation, the buffer would wait for the entire response to be streamed before synthesizing. Now, the buffer has a cap of 5 words. 
Extensively tested the random fact button. ChatGPT seems to be deterministic with random facts. From the ChatGPT website, I tried starting new multiple new conversations with the same prompt asking for a random fun fact and I got the same fun fact every time. Sun and I tested various ChatGPT parameters, but we could not stop the same fact from showing up repeatedly.  

Sun, Aaron, and I discussed the following action items for potentially reducing latency. 1 word chunking for synthesis sounds bad as tested today. Consider “dynamic” or “exponential” chunking for synthesis. The first word will be synthesized as a single word, then the next two words will be synthesized together, and so on. Some fine tuning will likely be required. At a certain point, synthesis will transition to chunking by punctuations. If 3.5 is drastically faster than 4, we can send the user query to 3.5 and 4, use the faster response from 3.5 to give the initial sentence or phrase, and then complete the response with 4. This introduces concerns regarding response flow. To resolve this, an alternate implementation of this idea is to get the response from 3.5. As the the first sentence of the 3.5 response is speaking, send the first sentence response from 3.5 with the user input to 4 and start synthesizing the rest of the response. We would essentially have the whole time it takes for the first sentence from 3.5 to finish speaking, to get the response and synthesize the first phrase of 4. Aaron also suggested the possibility of loading llama 2 on device to accomplish something similar. Rather than using 3.5 to generate the initial response, we could use an on device llama 2. However, there are size concerns as llama 2 is 1-2 GB. 

2023-11-02 Thu: [Fixed](https://github.com/harmony-one/x/commit/9161edd65b7714d9af34e3350dba1a109ac304f3) MockSpeechRecognition to match changed base class. Prepared for 3:30 pm onward event by testing product and loading demo. 

2023-11-01 Wed: Added tests for [AppConfig.swift](https://github.com/harmony-one/x/commit/f9fe3fb4f963e5589c18abf748eb635027e50dec), [Usage.swift](https://github.com/harmony-one/x/commit/ef92b990f2ed76f4579cf0a9ee5f1c2628ad45a8), [AudioPlayer.swift](https://github.com/harmony-one/x/commit/eb0d4e9163a2c0676324515ca083c3803358a874), [VibrationManager.swift, DashboardView.swift, and String.swift](https://github.com/harmony-one/x/commit/2b9946097c63c0c5a1aaa41064f2391b0c7bf225). Raised total test coverage by 10%. Fixed MockSpeechRecognition after SpeechRecognitionProtocol class was changed. 

2023-10-31 Tue: [Modified](https://github.com/harmony-one/x/commit/ec269538f031671e2e845d34281c738f58e0d94d) ActionHandlerTests.swift (a complete tearDownWithError(), added assert messages, and removed file header). Added tests for [Permission.swift](https://github.com/harmony-one/x/commit/f1e15f9d9a114c7185ee5e2cb4c9e6fadcb109c4) and [SpeechRecognition.swift](https://github.com/harmony-one/x/commit/5eb27dc0ea82e53446f4d07655d9c47609c3a186).

2023-10-30 Mon: [Removed animations](https://github.com/harmony-one/x/commit/fb2ac5bbf6c4b41970e9773345a99867019f526b). Started researching [live test attestation](https://developer.apple.com/documentation/devicecheck/establishing_your_app_s_integrity) data. 

---

2023-10-27 Fri: Added in [visual feedback](https://github.com/harmony-one/x/commit/db24712085daae84c8f9bee4e60a3996ff72ec61) for when the app is synthesizing. In progress: Ending the synthesizing indicator when the app starts speaking and starting the speaking indicator. 

2023-10-26 Thu: Worked on the [selection of voices](https://github.com/harmony-one/x/commit/b754c92eabc5942f74763e95416c4f1206a75900) (added Evan for the male voice per Theo P's request). Continued work on iOS 16 compatability changes. 

2023-10-25 Wed: Worked on duplicating code base and working on making a new version that is compatable with iOS 16 (Nagesh taking over). Worked with Sun to [implement](https://github.com/harmony-one/x/commit/2d881a3635251c8cade4778f9321046bef6daa92) a more pleasing voice (Ava enhanced) to his demo. 

2023-10-24 Tue: Created [settings page](https://github.com/harmony-one/x/commit/b93a5b0bbe4a02452fa0b17ec4a0e6ee20a7b285) per /app. Ran through change iterations Theo P to add support for more custom instructions and improve user clarity. There will be a selection for which profile to use and then a child menu to create a new custom instruction (Name & Custom Instruction fields). There will also be a user profile selection to add a name and description. 

2023-10-23 Mon: Pushed [PR build](https://github.com/harmony-one/x/commit/fbbe80dbe41c1d378dac74dfcb2d39ed2bff24dd) under Julia (bundle id: com.country.x.julie). Wrote up [deployment steps](https://www.notion.so/harmonyone/Deploying-Eve-to-Testflight-f77e9d2b6e864813ab6242d173ba48f5?pvs=4) to build and deploy apps to TestFlight for Sun and Yuriy. Working on resolving build issues (app builds directly from Xcode to iPad, but the installation from TestFlight is hung). 

---

2023-10-20 Fri: I built the edge build locally by resolving the missing AppConfig with the help of Aaron. Aaron also walked me through verifying and deploying the app to testflight (which I am now able to do with my credentials -- the most recent version of Ask Eve was deployed by me). I have started remaking Yuriy’s emotion build demo in swift. 

2023-10-19 Thu: Focused on collaborating with Yuriy to integrate the emotion build into the project. Yuriy is currently developing the application using React and hosting it as a web app on yuriy.x.country, and I am working on the cross platform react + expo stack to easily bring the app to iOS. 

2023-10-18 Wed: [Updated iOS app](https://github.com/harmony-one/x/commit/6c05a2aa64eb1b86b608124839631eba11026bd2) to display all available voices on device that the user can pick from (ie. native and user-downloaded) and added an icon. Assisted Theo F in loading app; he was able to confirm that downloaded premium and enhanced voices are accessible to apps. I will be investigating the best workflow to have the user download recommended voices. 

2023-10-17 Tue: Built a quick app that loads on [iPadOS 17.0.3](https://github.com/harmony-one/x/tree/main/mobile/samantha) that test the build in TTS synthesizer in iOS. While the speed is very very fast, the quality is very middling. Theo P has tested the various always available voices and selected 3 that are particularly good, and Theo F will test tomorrow. I will be looking into any potential methods for obtaining the [higher quality voices](https://developer.apple.com/documentation/avfaudio/avspeechsynthesisvoicequality/enhanced) that Apple has. However, these voices have to be downloaded on device before they can be used. 

2023-10-16 Mon: Downloaded the necessary simulators and application to build the iOS template. Beginning to study Swift/Obj-C (specifically focusing on audio classes that will be utilized). Through discussions with Frank, code refactoring for Discord bot will be done by tomorrow. 

---

2023-10-13 Fri: [Audio input testing](https://github.com/harmony-one/x/tree/main/audio_input_testing/end_to_end_test). Did some audio input testing in python. Synced with Stephen, will be shifting focus to transcription streaming APIs. Working with Theo P to determine metrics for user acceptance. 

2023-10-12 Thu: Set up Jupyter notebook to compare runtimes between PlayHT, Murf, Suno's Bark, and Vocode. Synced with Frank on the code structure of Discord Harmony bot and billing expectations. 
