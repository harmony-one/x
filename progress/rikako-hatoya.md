2023-12-02 Sat: Added haptics to "press and hold" button. Currently working on speech recognition test coverage.

2023-12-01 Fri: Tested and investigated issues for the flush rate + speech text delimiter for different languages (may rely on built-in libraries for NLP methods as given advice by Aaron, though still figuring out what's the best way for translations if we intend on adding more text). Investigated making speech recognition tests more comprehensive.

2023-11-30 Thu: Updated language support for button label text, added translations settings menu, answer limit warning text and delimiting punctuations for all languages. Replaced all warning messages given to the user through convertTextToSpeech()from just Strings to Strings returned from getFunctions() created in Language translation files [https://github.com/harmony-one/x/pull/291]. TO-DO: 1. test delimiting punctuations + flushing speed, translations of messages for different languages. 2. Investigate if manual translations is the best approach compared to API.

2023-11-29 Wed: Updated [AppConfig tests](https://github.com/harmony-one/x/commit/f6be1d1f759ebd4f764fa70d9e9f6552f6f6880b) to match new API key requirements. 
Made voice overs available in all iOS supported languages by creating dictionaries of translations. Fixed unavailable voice folder issue for some of the language-region codes passed to AVSpeechSynthesizer. Created a function to verify if language was supported otherwise default to English. Modified app to only take in language instead of language and region to ensure language support in textToSpeechConverter. Progress made in [branch](https://github.com/harmony-one/x/commits/rika-languages).
TO-DOs - 1. Buffer capacity needs to be modified for each language, since some languages such as Japanese have characters with longer pronounication and it takes time to flush the OpenAI response. 2. Currently, translations for basic messages are stored in a dictionary in order to reduce latency of requesting translation to OpenAI. However the main latency issue might just be due to buffer+flush rate. Investigate this so that if any other messages are added, we don't have to manually translate each message for each language.

2023-11-28 Tue: Worked on Timer Manager tests (90%) [https://github.com/harmony-one/x/pull/280] and RelayAuth tests. Investigated how to make some functions (surprise, etc) available in other languages.

2023-11-27 Mon: Raised the overall app test coverage from 61% to 74%. Worked on SpeechRecognition Tests [https://github.com/harmony-one/x/pull/272], raised its coverage from 40% to 90%. Investigating bugs for the SurpriseMe function when using the app in another language and updating Network Manager tests.

---

2023-11-26 Sun: Added some unit tests to speech recognition [https://github.com/harmony-one/x/pull/267]. Will need to implement mock text to speech converter and figure out how to oragnize the structure.

2023-11-25 Sat: Revised the code coverage to see tests that need more coverage. Observed that SpeechRecognitionTests was barely doing anything - saw that mocks had been implemented so far but they're not testing any of the actual functions. Started work on writing tests for this file, implemented tests for testGetCurrentTimestamp() and testRegisterTTS(), created MockTextToSpeechConverter [https://github.com/harmony-one/x/pull/262]. This file really needs refactoring for better organization as it is confusing to be using SpeechRecognition.swift for some test cases and others using MockSpeechRecognition.swift - will be working on this the next few days as solving the previous mentioned "View" SwiftUI issue seems a bit more complex.

2023-11-24 Fri: Continued investigating issues for creating unit tests for SwiftUI Views.

2023-11-23 Thu: Cleaned up test files for better structure and added all the missing test classes. Still investigating ActionsView unit test issues.

2023-11-22 Wed: Continued investigating resolutions for inability to access environment objects from a view during unit testing (issues pertaining to AppSettings and Store). Will look into frameworks for workarounds - StoreKit Testing and ViewInspector seems to be suggested.

2023-11-21 Tue: Worked on resolving ActionsView tests that were failing due to the setups of environment objects and views. [https://github.com/harmony-one/x/pull/240] Implemented theme manager and vibration unit tests, still investigating how to create unit tests for other functions since the original code needs refactoring to be testable.

2023-11-20 Mon: Created tests for [App Settings](https://github.com/harmony-one/x/pull/233) (90%), [Review Requester](https://github.com/harmony-one/x/pull/232) (81%), [Create User](https://github.com/harmony-one/x/pull/230) (100%), and [Timer Manager](https://github.com/harmony-one/x/commit/dcd7bae73e4ea719d0e7d1e1f33e33f92fc09714) (71%).

---

2023-11-19 Sun: Still working on debugging previous tests, been working on partitioning functions into smaller functions to make easier for testing.

2023-11-18 Sat: Worked on debugging to raise test coverage of Store.swift.

2023-11-17 Fri: Created tests for SettingsBundleHelper [https://github.com/harmony-one/x/pull/217] (coverage: 100%) and Store [https://github.com/harmony-one/x/pull/212]. Updated the tests for API Environment & Keychain Service [https://github.com/harmony-one/x/pull/213], and Persistence [https://github.com/harmony-one/x/pull/214], raising their coverage to 100%.

2023-11-16 Thu: Updated PermissionTests [https://github.com/harmony-one/x/pull/202]. Created unit tests for KeychainService [https://github.com/harmony-one/x/pull/204], APIEnvironment [https://github.com/harmony-one/x/pull/205], Persistence [https://github.com/harmony-one/x/pull/206] and raised all of their test coverage to 100%. Surveyed friends for feedback on app and generated quiz questions on Harmony. Fixed issue of some test files being ignored when opening project.

2023-11-15 Wed: Updated and merged haptics [https://github.com/harmony-one/x/pull/194]. Restructured Permissions.swift to better suit for unit test purpose, and added unit tests to [PermissionTests](https://github.com/harmony-one/x/commits/rika-permissiontests) for different cases of Microphone access and speech recognition authorization, raising its coverage to 81% in.

2023-11-14 Tue: Worked on increasing coverage for AudioPlayerTests (debugging [this](https://github.com/harmony-one/x/commits/rika-tests)). Worked on appconfig tests [https://github.com/harmony-one/x/pull/186] and [https://github.com/harmony-one/x/pull/187] (currently investigating unit tests to cover methods for decrypting API keys as they require a special workaround since they are private functions.)

2023-11-13 Mon: Added unit test for convertTextToSpeech.swift when language is supported by adding speak() in MockAVSpeechSynthesizer [https://github.com/harmony-one/x/pull/164]. Changed alert sounds ("beep") to only occur when there is recognition or OpenAI error in SpeechRecognition.swift [https://github.com/harmony-one/x/pull/175]. Removed the "share app" dialogue. Worked on unit tests for Audio Player (added test cases in AudioPlayerTests.swift, added mocks for AVAudioPlayer and AVAudioSession). Fixed errors regarding to merge conflicts.

---

2023-11-12 Sun: Worked on debugging unit test case for no language support in TextToSpeechConverterTests.

2023-11-11 Sat: Further implemented a unit test for TextToSpeechConverterTests to handle convertTextToSpeech() when provided device language is not available in the AVSpeechSynthesisVoice framework. Submitted PR: [https://github.com/harmony-one/x/pull/164]. Worked on unit test when voice is available for the language.

2023-11-10 Fri: Investigated debugging "IsFormatSampleRateAndChannelCountValid(format)". Implemented unit tests for TextToSpeechConverter, made a mock class for AVSpeechSynthesizer, updated TextToSpeechConverter by adding a protocol, and added code to make test debugging easier at breakpoints. Raised the overall test coverage for textToSpeech to a 93%, submitted PR: [https://github.com/harmony-one/x/pull/163].

2023-11-09 Thu: Debugging for bugs caused by unit tests requesting microphone permission (issue due to "IsFormatSampleRateAndChannelCountValid(format)" causes entire test to fail due to thread kill). Currently still working on it but so far: 1. Improved error handling for audioSession.recordPermission(). 2. Added NS microphone permissions requestg in Info.plist 3. Set up AVAudioSession properly by setting setCategory() and setActive() for AVAudioSession() 

2023-11-08 Wed: Resolved haptics issue which was earlier colliding with recording functions (PR: [https://github.com/harmony-one/x/pull/141]). Implemented language support so that app defaults to device's preferred first language instead of English (PR: [https://github.com/harmony-one/x/pull/143]). Debugging on compiling issues for running unit tests.

2023-11-07 Tue: Investigated a method to mitigate the haptics issue using UIImpactFeedbackGenerator and modifying SpeechRecognition.swift (Haptics feedback using AudioServicesPlayAlertSound() had bug: conflict with AVAudio when functions .playAndRecord() or .record() are in action). Investigated unit test failures due to new functions being implemented, which were leading to threading errors. Assisted Theo with preparation for the TGI event.

2023-11-06 Mon: Added context message rule to OpenAI service, added and debugged haptic feedback (vibration) when buttons are pressed, updated unit tests in ActionHandlerTests and MockSpeechRecognition to match new function sayMore(). 

---

2023-11-05 Sun: Changed "press to speak" to "press & hold". Added unit test coverage for play() function in ActionHandler.handle. Created MockGenerator for UIImpactFeedbackGenerator, implemented unit tests for stopVibration() and vibrate() in VibrationManagerTests, increasing its total coverage to 100%.

2023-11-04 Sat: Implemented unit tests for ActionHandler, increasing coverage from 55% to 96%.

2023-11-03 Fri: Learnt about testing (unit, integration, UI) in XCode, and how to do mock testing. Looked into missing parts of current test coverage within SpeechRecognition.swift and investigated how to incorporate their unit tests.

2023-11-02 Thu: Further investigated protocols inside MockSpeechRecognition.swift and various functions imported from AVFoundation used for SpeechRecognition.swift. Aided Theo with generating test codes for product demo.

2023-11-01 Wed: Understood concepts unique to Swift: protocol oriented programming (inheritance, extensions), classes vs. structs, enums for switch statements. Grasped the structure of XCode files (workspace, projects, targets, schemes).

2023-10-31 Tue: Synced with Sun on unit tests. Understood each function of SpeechRecognitionProtocols (reset, randomFacts, isPaused, capturing, cleanup). Debugged my build.

2023-10-30 Mon: Got onboarding documents done (signed up for Gusto and Google Workspace). Tested Whisper and Voice AI with Theo.

---
In 3 weeks (2023-11-20):
100% coverage of automated tests (units, components, submit, and release).

In 3 months (2024-01-30):
Make Voice AI compatible with 10 regions and dialects. 

In 3 seasons(2024-06-30):
Create a developer ecosystem. Curate a HuggingFace community. Build custom models of speech synthesis. Implement emotions by customizing annotation, pacing, excalamation and tones.

In 3 years (2026-10-30):
Understand ML architectures and LLMs. Build custom models, make project open source, build a developer community.

---
1. Native App / Open Source
Full-stack engineering is my strongest suit, as I work on building mobile apps using React Native through my current job. We are building a contact sharing app and have implemented features such as user dashboard and background location tracking to detect and display where contacts were added. I have also worked solo on a months-long personal project where I built an open source event sharing social media app using Google Cloud Platform and released it publicly on Expo.

2. Applied Mathematics / Optimization
During my graduate studies, I took courses on large scale data mining/complex networks, reinforcement learning, and optimization through linear programming. I utilized this knowledge while working on multiple Kaggle competition projects, as well as my research in Human Computer Interaction (HCI). Here I focused on transfer learning, applying clustering methods, and generating synthetic data to improve the quality of classification. I was also part of a mathematics olympiad team during undergrad, where I achieved a high score at the Putnam Mathematical Competition.

3. Parallelism
During my research internship at Caltech, I was part of a group called the LIGO collaboration where I developed our open-source Python library to classify different types of astronomical signals collected by the LIGO gravitational wave detectors. Our signals had strain dimensions of 10^-18, making it very difficult to detect our signals underlying in variant noise sources. To do this, we built a Python library and used ML to predict the types of signals. My task was to improve the classification accuracy of this library. I built a Python program to simulate variants of different astronomical signals, and then built a parallel program to simulate these signals at a large-scale in a significantly reduced amount of time. Each simulation cost approximately 1 minute and nearly 10,000 signals were simulated in an hour, reducing the time complexity by more than 99%.

https://rikah.netlify.app<br>https://github.com/rika97<br>https://www.linkedin.com/in/rikako-hatoya/<br>https://www.ted.com/profiles/7659431/translator
