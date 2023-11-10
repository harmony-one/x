2023-11-09 Thu: Debugging for bugs caused by unit tests requesting microphone permission (issue due to "IsFormatSampleRateAndChannelCountValid(format)" causes entire test to fail due to thread kill). Currently still working on it but so far: 1. Improved error handling for audioSession.recordPermission(). 2. Added NS microphone permissions requestg in Info.plist 3. Set up AVAudioSession properly by setting setCategory() and setActive() for AVAudioSession() 

2023-11-08 Wed: Resolved haptics issue which was earlier colliding with recording functions. Implemented language support so that app defaults to device's preferred first language instead of English. Debugging on compiling issues for running unit tests.

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

https://rikah.netlify.app
https://github.com/rika97
https://www.linkedin.com/in/rikako-hatoya/
https://www.ted.com/profiles/7659431/translator
