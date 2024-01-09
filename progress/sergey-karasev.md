2023-12-20 Tue - 2024-01-05 Fri: Paid time off.

---

2023-12-19 Mon: I am continuing to work on integration [Gemini Pro](https://github.com/harmony-one/x/pull/392).

---

2023-12-15 Fri: I am working on integrating [Gemini Pro](https://cloud.google.com/vertex-ai/docs/generative-ai/start/quickstarts/quickstart-multimodal). I have [created draft client and component tests](https://github.com/harmony-one/x/pull/392).

2023-12-14 Thu: I worked on the [DataFeed tests]((https://github.com/harmony-one/x/pull/380)) and start working on integration Vertex AI API.

2023-12-13 Wed: I [added tests for the DataFeed](https://github.com/harmony-one/x/pull/380), resulting in a code coverage of 93.2%. Also, I researched how to get rid of code coupling and which pattern is better to apply.

2023-12-12 Tue: I [fixed the bug](https://github.com/harmony-one/x/pull/354) causing the Pause/Play button not to turn red. I have [added the menu buttons](https://github.com/harmony-one/x/pull/359) for the following: Telegram Group and Premium Voices.

2023-12-11 Mon: I am continuing to work on the UserAPI component tests. I have [added component tests for the methods deleteUserAccount, updateUser, purchase, and register](https://github.com/harmony-one/x/pull/334) and code coverage for UserAPI has increased to 97.3%.

---

2023-12-08 Fri: I have [added the ability to implement test mocks](https://github.com/harmony-one/x/pull/334) for the NetworkManagerProtocol and added a test for the UserAPI.getuser method.

2023-12-07 Thu: I am working on component testing and investigating how to increase code coverage, and [updated the tests](https://github.com/harmony-one/x/pull/328) for the following components: GridButton, NetworkManager, VibrationManager, and OpenAIService.

2023-12-06 Wed: I'm working on test coverage and encountered an SSL problem in the development environment.

2023-12-05 Tue: I have [added the "Open Settings" shortcut](https://github.com/harmony-one/x/pull/312) and updated the "Surprise ME!" shortcut.

2023-12-04 Mon: I have started working on the iPhone 15 [action button that triggers the "Surprise Me!" feature](https://github.com/harmony-one/x/pull/303), and I am researching how to implement metrics for the signing key proxy, and subsequent requests.

---

2023-12-01 Fri: I am working on a bug in the server-side user whitelist checker.  

2023-11-30 Thu: I have started to explore how to perform fuzzing, but I couldn't find a testing fuzzing toolkit (the ones I found are over 4 years old), and I assume we will have to create our own tools.

2023-11-29 Wed: I have [added snapshot tests for the GridButton](https://github.com/harmony-one/x/pull/286) component and updated the tests for the ProgressView component.

2023-11-28 Tue: I have [added a snapshot test for the ProgressView](https://github.com/harmony-one/x/pull/278) component and updated the AutoPlayer tests.

2023-11-27 Mon: I have [added unit tests for the NetworkManager](https://github.com/harmony-one/x/pull/268), for the setAuthorizationHeader method and for the bad response case. I also deleted the unused code.

---

2023-11-24 Fri: I have [added unit tests](https://github.com/harmony-one/x/pull/256) for the cancelOpenAICall and query call with the rate limit set to false.

2023-11-23 Thu: I expanded the OpenAIStreamService so that it can be tested using unittest. I have [added unittests](https://github.com/harmony-one/x/pull/248) for the stream processing from OpenAI, rate limiting, and other methods of OpenAIStreamService.

2023-11-22 Wed: I'm working on expanding the [tests for the OpenAI service](https://github.com/harmony-one/x/pull/248).

2023-11-21 Tue: Working on [UI tests](https://github.com/harmony-one/x/pull/236): Fixed the test for the "Pause / Play" button, fixed the test for the "Surprise ME!" button, and started work on the test for the "New Session" button.

2023-11-20 Mon: Working on Bluetooth support. I have checked all of my devices, and the app is functioning properly with AirPods, JBL earbuds, JBL Extreme 2, and a Xiaomi Bluetooth receiver. Also I have added [AirPlay support](https://github.com/harmony-one/x/pull/227). I have added ["repeat last" button test](https://github.com/harmony-one/x/pull/229).

---

2023-11-17 Fri: I removed the rate limit for the "surprise me" feature https://github.com/harmony-one/x/pull/210 and working on ui tests.

2023-11-16 Thu: I'm working on UI testing, restoring the functionality of UI tests, [added dependencies and deleted non-functional and outdated tests](https://github.com/harmony-one/x/pull/198).

2023-11-15 Wed: I have added a delay for ["press to speak"](https://github.com/harmony-one/x/pull/188) when a user leaves the button. Working on [integrating user verification](https://github.com/harmony-one/x/pull/190/commits/73235135801418805a704a04765b6756e1d24796) into whitelist, as to not expose secrets.

2023-11-14 Tue: I have added [whitelist user in system settings](https://github.com/harmony-one/x/pull/179), added [AI credits](https://github.com/harmony-one/x/pull/179/commits/bb91398cb4ce08c36b16ea135ad0adbb395baaa6) in system settings. Fixed and [extended tests of a context limiter](https://github.com/harmony-one/x/pull/179) and I made it so that the Context Limiter doesn't delete user messages, and the assistant's messages are now trimmed down to a single sentence, Added [Premium Use Expires](https://github.com/harmony-one/x/pull/179/commits/d9f0907322d930a4d17faff995a990cee3da84a7) in the settings.

2023-11-13 Mon: I am working on the "tap-to-speak" button, sometimes its state may conflict with other buttons in the user interface. I have resolved the [issue with quick switching between "tap-to-speak" and "hold-to-speak"](https://github.com/harmony-one/x/pull/169). 

---

2023-11-10 Fri: Working on [truncating the accumulating context to a maximum of 512 characters](https://github.com/harmony-one/x/pull/159) and adding unit tests for the "limiter", [added the same logic to harmony one bot](https://github.com/harmony-one/HarmonyOneBot/pull/343). 

2023-11-09 Thu: I have added [a window to display a link to the application](https://github.com/harmony-one/x/pull/142) (share feature) after the user taps "new session" button for the seventh time, also [added a throttler](https://github.com/harmony-one/x/pull/144) to the reset session function (in order not to interrupt the greeting). Clarified the code regarding tap-to-speak and [fixed the play-pause button state](https://github.com/harmony-one/x/pull/149)

2023-11-08 Wed: Working on "[Tap to Speak & Tap to Send](https://github.com/harmony-one/x/pull/137)" feature, made the button interruptible if other buttons are pressed, [Prompt an app store feedback](https://github.com/harmony-one/x/pull/140) window after the user hits a new session seven times.   

2023-11-07 Tue: [Fix the play/pause button](https://github.com/harmony-one/x/pull/130) state and [working on say more/random fact buttons](https://github.com/harmony-one/x/pull/131) (doesn't work when tapped for the first time) 

2023-11-06 Mon: Working on "new session" feature: button should trigger a greeting [only once](https://github.com/harmony-one/x/pull/122)

---

2023-11-03 Fri: I am working on a user interface test for the [GridButton component](https://github.com/harmony-one/x/pull/119).

2023-11-02 Thu: [Fixed the animation](https://github.com/harmony-one/x/pull/108) when changing the device orientation [Pause if the user slides up](https://github.com/harmony-one/x/pull/113) and prevent the pause button from flickering, [Removed](https://github.com/harmony-one/x/pull/116) the beep sound if the user slides up

2023-11-01 Wed: I was working on the implementation of app functions ([stop all interactions](https://github.com/harmony-one/x/pull/99/files)) when the user swaps the app upwards

2023-10-31 Tue: Added dark blue highlight as default for “press to speak” button, added highlight “pause / play” when audio is playing, and updated random fact query in this [PR](https://github.com/harmony-one/x/pull/93). Integrated UI unit tests in this [PR](https://github.com/harmony-one/x/pull/91). 

2023-10-30 Mon: Working on unit tests for UI components from Actions module, update with new logo, and migrated harmony one bot to another server

---

2023-10-26 Fri: I worked on user [interface bugs](https://github.com/harmony-one/x/pull/79) and fixed the order of the buttons in landscape mode. I also refactored the code for the buttons.

2023-10-25 Thu: Reviewed Aaron's pull requests, watched an iOS/Swift developer course, and starts working on [chatgpt stream](https://github.com/harmony-one/x/pull/73) application programming interface

2023-10-25 Wed: Implemented [Newest UI](https://github.com/harmony-one/x/commits?author=ahiipsa) for Voice AI based on Alaina's Figma model.

2023-10-24 Tue: Worked on [google text to speech for iOS application](https://github.com/harmony-one/x/pull/62), deployed testflight build "Sergey", spoke with Yuri and Artem to share knowledge about Xcode and project setup.

2023-10-23 Mon: Worked on [adding deepgram](https://github.com/harmony-one/x/pull/56) (speech recognition) to the iOS application

---

2023-10-19 Fri: [Added autorun and removed user interface](https://github.com/harmony-one/x/pull/51) (microphone button and status loader) from vocode demo, and [reviewed Yuriy's pull request](https://github.com/harmony-one/x/pull/51) with the Azure API, And also started working on ios application /x/ios-annie (deepgram nova 2 and google)

2023-10-19 Thu: Worked on custom [instructions for vocode demo](https://github.com/harmony-one/x/pull/43), and have started working on voice interruption for vocode demo

2023-10-18 Wed: I have finish [google tts proxy](https://github.com/harmony-one/x/pull/36) and added it to main demo, switched vocode demo to [deepgram nova2 model](https://github.com/harmony-one/x/pull/40) and [openai gpt4 model](https://github.com/harmony-one/x/pull/37), and [hidden mic settings](https://github.com/harmony-one/x/pull/38) for vocode demo   

2023-10-17 Tue: Worked on [voice interruption](https://github.com/harmony-one/x/pull/26), [fixed](https://github.com/harmony-one/x/pull/31) production version (black screen mode), also I have started working on setting up Google TTS for the main demo.

2023-10-16 Mon: Working on ios speech recognizing feature, added [demo](https://github.com/harmony-one/x/tree/main/ios-demo-recognizing-speech), to publish the application through TestFlight, I am waiting for my account to be approved.

---

2023-10-13 Fri: I have set up a demo for vocoding (server and [client](https://github.com/harmony-one/x/commit/4f44ca2c80ec96b7388ffc065c4c2733c8e5ff6d)), also worked on speech interruption and added a [voice detection module](https://github.com/harmony-one/x/commit/0a483ce00e14223f8ba95dc95936494f8a3cc7bf)

2023-10-12 Thu: I worked on launching a [demonstration](https://github.com/harmony-one/x/pull/11) of the interview bot from Vocode. They used their own API which is currently not functioning. I also worked on the [application modes](https://github.com/harmony-one/x/pull/12) (black screen). I separated the code into parts and encountered some problems with speech recognition. 

2023-10-11 Wed: I worked on [yak benchmark](https://github.com/harmony-one/yakGPT/commit/8e078135f420fd51a1d4b4e021102b13e8e352c8), ыince the code is nonlinear, I have added metrics to the console log for now and I am continuing to work on the metrics in order to display them on the page.  

2023-10-12 Tue: I worked on a mobile application for iOS. I set up the development environment and created a [project](https://github.com/harmony-one/x/commit/75e49d6dda803119b224bbc3ccacc68d6fa68b7a). I studied how to work with the microphone in React Native. I also [configured Yak GPT and published it](https://yak-gpt.fly.dev/).

2023-10-12 Mon: I explored the Telegram API call and Twilio for technical limitations and the possibility of integrating with streaming audio and integration with GPT-4. And also started working on a mobile application.
