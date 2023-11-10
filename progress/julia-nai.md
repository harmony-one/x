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

Sun, Aaron, and I discussed the following action items for potentially reducing latency:
- 1 word chunking for synthesis sounds bad as tested today. Consider “dynamic” or “exponential” chunking for synthesis. The first word will be synthesized as a single word, then the next two words will be synthesized together, and so on. Some fine tuning will likely be required. At a certain point, synthesis will transition to chunking by punctuations. 
- If 3.5 is drastically faster than 4, we can send the user query to 3.5 and 4, use the faster response from 3.5 to give the initial sentence or phrase, and then complete the response with 4. 
    - This introduces concerns regarding response flow. To resolve this, an alternate implementation of this idea is to get the response from 3.5. As the the first sentence of the 3.5 response is speaking, send the first sentence response from 3.5 with the user input to 4 and start synthesizing the rest of the response. We would essentially have the whole time it takes for the first sentence from 3.5 to finish speaking, to get the response and synthesize the first phrase of 4. 
    - Aaron also suggested the possibility of loading llama 2 on device to accomplish something similar. Rather than using 3.5 to generate the initial response, we could use an on device llama 2. However, there are size concerns as llama 2 is 1-2 GB. 

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
