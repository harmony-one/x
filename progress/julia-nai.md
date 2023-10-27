2023-10-26 Thu: Worked on the [selection of voices](https://github.com/harmony-one/x/commit/b754c92eabc5942f74763e95416c4f1206a75900) (added Evan for the male voice per Theo P's request). Continued work on iOS 16 compatability changes. 

2023-10-25 Wed: Worked on duplicating code base and working on making a new version that is compatable with iOS 16 (Nagesh taking over). Worked with Sun to [impliment](https://github.com/harmony-one/x/commit/2d881a3635251c8cade4778f9321046bef6daa92) a more pleasing voice (Ava enhanced) to his demo. 

2023-10-24 Tue: Created [settings page](https://github.com/harmony-one/x/tree/main/voice/VoiceAI) per /app. Ran through change iterations Theo P to add support for more custom instructions and improve user clarity. There will be a selection for which profile to use and then a child menu to create a new custom instruction (Name & Custom Instruction fields). There will also be a user profile selection to add a name and description. 

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
