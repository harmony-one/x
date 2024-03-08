2024-03-08 Fri: Implemented a custom three-dot animation, addressed drop caps issues, and deployed the updates to TestFlight.

2024-03-07 Thu: Added custom fonts. Removed the 'Share' button, 'My Location' button, and marker pop-ups to streamline UI Increased microphone button size for better user accessibility.Implemented feature to drop a marker at the current location and start audio recording upon 'Record' button click. Added functionality to copy text to the clipboard for user convenience. After transcription ends, an 'X' button now temporarily overlays the microphone button for 5 seconds.

2024-03-06 Wed: The speech-to-text function has been refactored, a share icon has been added with a function, the Memos view has been redesigned, the image carousel has been removed and drop caps for memo text, and the issue of "This voice memo could not be processed" has been fixed.

2024-03-04 Tue: Currently addressing a bug where the map does not relocate to the dropped pin.

2024-03-04 Mon: Reviewed the pull request at https://github.com/harmony-one/1/pull/12 and incorporated the changes into the codebase. Performing testing. 

--- 

2024-03-01 Fri: Refactored Google API integration into a separate file and updated map positions to align with image scrolling and refactoring the code.

2024-02-29 Thu: Implemented the app's new design and updated the Carousel Reference for images.

2024-02-28 Web: Redesign of the app, with some updates currently underway.

2024-02-27 Tue: Reintroduced cycling pins on the map with counts and temporarily concealed the functionality to add photos.

2024-02-26 Mon: Modified the camera string in the plist file and deployed a new version to TestFlight.

---

2024-02-23 Fri: Implemented moving the carousel to focus on newly added pins, introducing a blinking animation for the microphone, and modifying the address display in the transcript to only show up to the first comma. Additionally, the Check-In feature has been removed, and a button has been added for photo uploads and photos will now be displayed in the carousel at their current positions.

2024-02-22 Thu: Removed settings and action sheet view; expanded the carousel to occupy the entire bottom view, introduced reverse geocoding for recording pins, re-enabled microphone functionality in event pop-up to enable adding transcripts to locations; added functionality to move the map to the corresponding location when scrolling through the carousel, and added a fixed transcript/photo modal at the bottom of the screen and deployed them to the TestFlight

2024-02-21 Wed: Implemented a carousel view that displays information from markers and added a microphone icon on the map view. After recording, a pin will appear at the location, and the carousel's transcript will be updated. Integrated CodePush functionality, pending testing.

2024-02-20 Tue: Implementing a feature for real-time app updates that circumvent the App Store, currently examining CodePush. Reverting changes to the app's original red pin icons and developing a user interface featuring a black box that displays an image, text, and location information.

---

2024-02-13 Tue to 2024-02-19 Mon on planned leave.

2024-02-12 Mon: Added an action sheet filled with data from pins. Selecting a pin now leads to the market location it represents, with an updated navigation icon. Also, revised the hardcoded address by omitting text following the first comma.

-- 

2024-02-09 Fri: Implemented a current location button with functionality, incorporated speech-to-text conversion using the "whisper-1" model, added a checkbox beside "Check-In" that fills upon selection, renamed "Voice Memo" to "Memo," added a microphone icon to its left, and pushed these changes to TestFlight.

2024-02-08 Thu: Initiated a new React Native project, incorporating mapview and additional modifications within the 'socialmap' folder, alongside implementing an audio recording feature. These changes have been deployed to TestFlight.

2024-02-07 Wed: I integrated a React Native map view with static pins and committed the updates to a 1 repository.

2024-02-06 Tue: I've been diving into Farcaster, reviewing its documentation, and came across an unofficial SDK for Flutter at https://pub.dev/packages/farcaster_sdk. I successfully compiled the code locally.

2024-02-05 Mon: Working on the Voice-on app and implementing location services to retrieve the address. This address is then displayed when saving audio recordings. Additionally, we made changes to the app and deployed them to the TestFlight 

---

2024-02-02 Fri: Eliminate the start screen, resize the MetaMask logo to be smaller and incorporate eyes, encase the MetaMask logo in a simple border to enhance its button appearance, ensure the "Add Owner Key" prompt does not appear initially, and deploy these updates to TestFlight.

2024-02-01 Thu: Update tasks to remove the "Read-only" label, hide Send/Receive in Read-only mode, display the full address centered, add a "Connect Metamask" button from "Add key", limit assets display to the first with selection option and remove Harmony, and center the pop-out button for improved accessibility.

2024-01-31 Wed: Ensuring automatic retrieval of the Harmony address upon user access to the Harmony safe, followed by uploading this functionality to TestFlight, has been completed.

2024-01-30 Tue: Removed the passcode screen and user image from the nav bar, added clipboard functionality for addresses, removed the 'add new' button, corrected the harmony icon display, and set the target exclusively to production.

2024-01-29 Mon: Resolved issues related to the submodule paths in the iOS Telegram fork, updated app icons, and app name. Pushed all the changes. 

---  

2024-01-26 Fri: Republic Day Holiday.

2024-01-25 Thu: Removed the bottom navigation bar, reformatted the code, and then uploaded the revised X-Safe application build to TestFlight for testing.

2024-01-24 Wed: Removed the onboarding screen, the 'My Safe' account option from settings, and the network selection screen from the app. Also, deleted the 'How it Works' screen and the transaction screen. Subsequently, the updated version of the X Safe app was uploaded to the TestFlight build for testing.

2024-01-23 Tue: Created new development bundle IDs for the Telegram iOS project, updated the repository with these changes, and uploaded a X-safe project to TestFlight.

2024-01-22 Mon: Configured the Telegram iOS project and committed the changes.

---

2024-01-19 Fri: I am currently setting up the MetaMask code for iOS locally and have successfully executed the iOS SDK code. Next, I am focusing on getting the React Native code up and running, and all changes have been pushed.

2024-01-18 Thu: Removal of the Test network and the 'hmy' prefix from addresses in the receive function, the exclusion of a chain prefix in the QR code display, enhanced visibility with added color to the Harmony feature, accessible Privacy Policy and Terms and Conditions, and the elimination of the 'Learn More' option in the queues section.

2024-01-17 Wed: Exploring the Keplr Wallet code and setting it up to run locally.

2024-01-16 Tue: Upgraded Safe Client Gateway Services, corrected gasPrice rpc to latest, and eliminated the demo account link.

2024-01-15 Mon: Holiday

--- 

2024-01-12 Fri: Currently examining the project's codebase.

2024-01-11 Thu: Created development, staging, and production bundle IDs for the Safe project and updated the repository after making these changes. Currently examining the project's codebase.

2024-01-10 Wed: Set up safe-iOS project and pushed changes.

2024-01-09 Tue: Ehance whisper waiting time is in progress.

2024-01-08 Mon: Added MP3 greeting message functionality and cancel method for OpenAITextToSpeech. Removed the download message for premium voice. Updated the UI for the pause/play feature.

--- 

2024-01-05 Thu: Whisper integration for Talk to me with queue.

2024-01-04 Thu: Whisper integration for Talk to me is in progress. 

2024-01-03 Wed: Completed Open AI’s whisper integration for Press & Hold and Tap to speak.

2024-01-02 Tue: Started Open AI’s whisper integration in the voice AI app.

--- 

2023-12-29 Fri: Removed favourite. Loop twitter tweets to talk to me.

2023-12-28 Thu: Added a favorite feature on Twitter that communicates with Talk to Me.

2023-12-27 Wed: Add a feature to display Twitter lists. Implement functionality for adding new items to lists. Add a feature for item deletion from lists. Enhance the system by updating status type handling.

2023-12-26 Tue: Twitter API's testing and UI for update API.

---

2023-12-22 Fri: Implemented new version of Twitter APIs, manually added new Twitter list updated Twitter list name, or set it in "active" or "inactive" status and Delete.

2023-12-21 Thu: Completed and tested "Skip 30 Seconds" feature to an action sheet, PR: https://github.com/harmony-one/x/pull/410.

2023-12-20 Wed: Task to add a "Skip 30 Seconds" feature to an action sheet, work in progress.

2023-12-19 Tue: Project setup, launch screen integration, network manager added, audio management functionality, feature for Saving Recorded Audio, functionality to display a list of saved recordings.

2023-12-18 Mon: AlertManager unit test 100%.

---

2023-12-15 Fri: Add a "Mirror" toggle in settings to switch column sides PR: https://github.com/harmony-one/x/pull/389. For "Share transcript", remove the loading spinner and optimize load time PR: https://github.com/harmony-one/x/pull/390. Reviewed PR: https://github.com/harmony-one/x/pull/388.

2023-12-14 Thu: Resolved bug where "Press & Hold" disappears and fixed settings bug. PR: https://github.com/harmony-one/x/pull/383.

2023-12-13 Wed: Reorganized menu display, and updated intro image. PR: https://github.com/harmony-one/x/pull/372. 

2023-12-12 Tue: Added loading icon for a period when a shared transcript is loading and tested error handling for speech recognition with appropriate haptic feedback. PR: https://github.com/harmony-one/x/pull/343.

2023-12-11 Mon: Aligning error handling for speech recognition with appropriate haptic feedback, testing is in progress.

---

2023-12-08 Fri: Update the "referral account" to include Artem's endpoint PR: https://github.com/harmony-one/x/pull/332. Complete the enhancement of the premium voice detection feature PR: https://github.com/harmony-one/x/pull/331.

2023-12-07 Thu: Modified the "Press & Hold" feature to provide haptic feedback only upon finger release and added a vibration every second during the wait for a response.
Evaluated the MobSF security framework and implemented a check for user access to premium voice features, with a alert for those without access.

2023-12-06 Web: Implemented a 'Thinking' image with a play button that activates on press and hold, enhancing user interaction. Resolved alert-related issues in settings for improved UI stability. Integrated a beep sound for failed API calls for better user feedback and fixed vibration manager unit test cases.

2023-12-05 Tue: Eliminated the loading circle displayed during in-app purchase activation and added a sign-out feature.

2023-12-04 Mon: Resolved issues with Mixpanel(PR: https://github.com/harmony-one/x/pull/298) and developed a specialized settings view for iPad (branch: https://github.com/harmony-one/x/tree/customSettingView).

---
2023-12-01 Fri: Implemented an action sheet for the "Purchase Premium" feature PR: https://github.com/harmony-one/x/pull/292, along with the integration of Mixpanel analytics. Additionally, events for button actions have been set up PR: https://github.com/harmony-one/x/pull/293. The development of an iPad popover view is currently underway.

2023-11-30 Thu: Add account deletion feature with API integration and keychain clearance PR: https://github.com/harmony-one/x/pull/287. Fixed missing files in master PR: https://github.com/harmony-one/x/pull/288.

2023-11-29 Wed: Implement Version Check and Alert System from the iOS side.

2023-11-28 Tue: Unit tests for share link and activity view. Addressed the SwiftLint warnings as well. PR: https://github.com/harmony-one/x/pull/275. 

---
2023-11-24 Fri: Merged & resolved conflicts : https://github.com/harmony-one/x/pull/253, https://github.com/harmony-one/x/pull/251, https://github.com/harmony-one/x/pull/181. Added review comments on PRs: https://github.com/harmony-one/x/pull/250, https://github.com/harmony-one/x/pull/248, https://github.com/harmony-one/x/pull/247.

2023-11-23 Thu: When a user logs into the application and encounters the in-app purchase process, if they choose to cancel the purchase, a blank screen appears. This issue has been resolved in a recent Pull Request: https://github.com/harmony-one/x/pull/251. However, there's an observation that if a question is asked quickly during this process, the response given pertains only to the previous question.

2023-11-22 Wed: 'Sign in' to 'Sign In', show user ID/email when signed in, added 'Save Transcript' in settings, and implemented a loading icon on 'Purchase'. PR: https://github.com/harmony-one/x/pull/244

2023-11-21 Tue: I have resolved all conflicts for the Pull Request:https://github.com/harmony-one/x/pull/181, implemented some of the SwiftLint rules, and assisted Frank with unit testing.

2023-11-20 Mon: Added handling of decline permissions, Long Press "Tap to Speak" should trigger login. Long Press "New Session" should trigger In App Purchase. Currently, 1/10 times the review pops up. Remove review, update to 1/5 times In App Purchase pops up, but only when the user is not logged in or the user is logged in but doesn't have premium.

---
2023-11-17 Fri: Implemented where the payment modal is triggered immediately after user sign-in. Resolved all conflicts present in the pull request. Collaborated with Theo to integrate data.ai.

2023-11-16 Thu: Updated server post-purchase to display a new expiration date on the settings page, assisted Artem with In-App Purchases, and helped Frank resolve unit testing build issues.

2023-11-15 Wed: Implemented login prompt for long-press on "New Session", secure keychain storage, server API network manager, and in-app purchase offer for logged-in users.
Added user creation with Apple login for 'Artem' on the server; facing issues with delegate not being called when users cancel login, preventing in-app purchase modal display.

2023-11-14 Tue: SwiftLint was integrated into the project. Custom rules were established for coding standards, and issues identified by SwiftLint were resolved. Sentry uploads dsym file using the Xcode build script is in progress. (but using a sentry-cli command without Xcode is done)

2023-11-13 Mon: Completed implementation of In-App Purchases compatible with iOS 14 and began integrating the logging of input and output tokens in the iOS local database.

---

2023-11-10 Fri: I am currently working on making In-App Purchases (IAP) compatible with iOS 14 and am assisting Artem with support regarding IAP.

2023-11-09 Thu: Enhanced compatibility with iOS 14 and a new timer mechanism has been added to the application, which initiates a countdown for 5 minutes.

2023-11-08 Wed: Implement AirPods compatibility and prompt for a 5-star App Store review when initiating a new session. Reviewed:https://github.com/harmony-one/x/pull/124/

2023-11-07 Tue: Enhanced the button click responsiveness for the functions 'say more', 'repeat last', 'press & hold', and 'random facts'. Reviewed PR: https://github.com/harmony-one/x/pull/124 and discussed with Artem on Apple Pay implementation for credits.

2023-11-06 Mon: Enhanced compatibility with iOS 15 and improved the responsiveness of the reset button through correct thread management.

---

2023-11-03 Fri: Implemented component testing for both AudioEngine and AudioSession. Additionally, I've resolved a bug where the Repeat button was only capturing the last of the stream.

2023-11-02 Thu: Fixed the issue related to changes in orientation. I also removed haptic feedback from the thinking process. Currently, I am actively working on component testing for both AudioEngine and AudioSession.

2023-11-01 Web: I have created a one-page document on Component and End-to-End Testing for the Speech Recognition System, and provided support to Artem and Sergey in their task. PRs reviewed https://github.com/harmony-one/x/pull/102, https://github.com/harmony-one/x/pull/99, https://github.com/harmony-one/x/pull/100.

2023-10-31 Tue: Added a new MP3 file and fixed playback issues. Assisted Sergey with UITest challenges.

2023-10-30 Mon: Implemented audio interruption for the "Random Fact" button during GPT's speech playback.Fixed the app-breaking issue caused by spamming the "Press to Talk" button. Generated a TestFlight build labeled as version 0.8.2(7). Continuing with the remaining unit tests as listed.

2023-10-29 Sun: Implemented the ActionHandler class to manage button actions, prioritizing unit testability. Introduced a SpeechRecognition protocol to enhance unit testing capabilities. Created ActionHandlerTests, featuring an initial test case. Developed mock objects to emulate speech and text-to-speech operations for testing purposes. Included a README file with instructions for conducting tests and writing unit tests.

---

2023-10-27 Fri: 1. Started integrating Aaron's Deepgram with the OpenAI stream in the Voice AI module. 2. Reviewed Frank's pull request and successfully merged the changes into the main branch.3. Bug Fix: Resolved an issue where users could hold the press-to-speak button to begin recording, and upon release, the recording would be sent to ChatGPT. Due to device orientation changes causing a shift in button positions, the recognition task has been temporarily suspended. 4. Generated a TestFlight build labeled as version 20, which includes the updates from points 2 and 3.

2023-10-26 Thu: Updated the app to ensure compatibility with iOS 16 and resolve the UI scrolling problem. Pushed these changes to TestFlight build version 17. Also, Currently reviewing Aaron's streaming code and merged https://github.com/harmony-one/x/pull/68 and pushed a new build to TestFlight build version 18.

2023-10-25 Wed: Implemented the Vibration Manager and URL session cancellation, along with the integration of continuous vibration signaling during the openAI call. These changes have been successfully pushed to TestFlight build version 11. Due to the restructuring of the folder, some code was inadvertently missed in the audio play. I have rectified this issue by reintroducing the missing code and also included the soft beep MP3 file.

2023-10-23 Mon: I have implemented a new design for the button screen and updated the hardcoded ONE value to 2111.01 ONE on both the dashboard and button screens. Additionally, I added a "press to speak" functionality and incorporated a soft beep that sounds every second to indicate that ChatGPT is processing a response. I completed all remaining button functionalities except for the 'Fast Forward' action. Presentation mode has also been enabled for the application. The Dashboard code has been temporarily commented out, but can be easily reintegrated in the future if needed.

---

2023-10-20 Fri: I implemented a fresh design for the button screen, featuring buttons for pause, reset, speak, cut, hide, and repeat. I also focused on refining their respective action functionalities. However, the reset action is encountering certain issues that require further attention. I addressed the font-related problem occurring in portrait mode and applied the necessary fixes. Subsequently, I have deployed the most recent changes to TestFlight for evaluation. 

2023-10-19 Thu: Implemented buttons on a new screen for pause, reset, speak, cut, hide, and repeat, and currently working on their action functionalities.

2023-10-18 Wed: Upgraded speech detection, integrated ChatGPT4, added Apple's text-to-speech, and implemented Figma's design specifications.

2023-10-17 Tue: Currently, I am developing an end-to-end demo for iOS. As part of this project, I have successfully integrated a text-to-speech functionality leveraging Apple's native capabilities. Presently, I am focused on refining the speech-detection component of the project.

2023-10-16 Mon: Successfully utilized SwiftUI to create a dynamic dashboard design, ensuring seamless adaptation to both portrait and landscape orientations. The dashboard prominently displays a central text element and incorporates essential static information in all four corners.

---

2023-10-14 Sat: Per [x.country/sam](x.country/sam), the first task is to build the first and only screen. For now, just display a number "256 ms" to indicate the end-to-end latency. Then: The overall system at center and 3 component latencies, measured as 5-second running averages, are for optimizing network and API performance of speech recognition, ChatGPT4 response, speech synthesis.


Bio: Experienced Lead iOS Engineer with a demonstrated history of working in the computer software industry. Skilled in, Swift, Objective-C, CoreData,Github, SQL, C++, OpenCV, Continues integration and Agile Methodologies. Strong information technology professional with a Master of Computer Applications (M.C.A.) focused in Computer Science from Loyola Academy.

https://www.linkedin.com/in/nageshkumarmishra
