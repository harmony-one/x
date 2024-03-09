2024-03-08 Fri: Fixed an issue with the Social Map app that sent the [wrong file format](https://github.com/harmony-one/1/pull/13) to the harmony-llm-api for voice transcript.

2024-03-07 Thu: Keep researching Peapods Finance. Here is a good [video](https://www.youtube.com/watch?v=fW87F-l30KI) explaining how the pods work. Also, here is the last [Audit report](https://reports.yaudit.dev/reports/01-2024-Peapods/), but their repo is private. 

2024-03-06 Wed: Started researching Peapods Finance. They do not share the contracts; the only contract shown is their rewarded token, PEAS.

2024-03-05 Tue: Checked Voice AI app functionality after malfunctions reports. Tested the app live and locally, checked the Sentry log where some issues were found, and discussed them with Aaron; they seem to be isolated issues. Will keep monitoring the app in the following days. Also, I worked on a [hotfix](https://github.com/harmony-one/h.country/pull/105) on h.country where a private key import was leaked, and the filter was showing full-text tags.  

---
2024-03-01 Fri: Finished code refactoring and Typescript migration of [ONE Map app](https://github.com/harmony-one/1/pull/12): created ImageCarouselComponent and MemoCarouselComponent, also fixed recording logic.

2024-02-29 Thu: Worked on the following [tasks on h.country](https://github.com/harmony-one/h.country/pull/103): Updated the logic of the clear query param. Also worked on the following [tasks ONE Map](https://github.com/harmony-one/1/pull/11): Refactored MapViewComponent, by creating MapMarker component while migrating the code to Typescript.

2024-02-28 Wed: Worked on the following [tasks on h.country](https://github.com/harmony-one/h.country/pull/101): Updated the display of link actions because most of the time, it took two lines to show 0/B1B1 1760886692 x/17608866 (from address, username, type/username). The proposed change shows the address and the type/username info (0/B1B1 x/17608866). Also, updated the action type color, showing blue if the from address is the same as the page wallet address (key) and yellow otherwise. Also, updated the href to navigate to the payload URL; Fixed filter panel when clicking actions' from/to address. Also worked on the following [tasks ONE Map](https://github.com/harmony-one/1/pull/10): Added a UserContext to handle user wallet address, and useStorage hook to handle local storage.

2024-02-27 Tue: Worked on the following [tasks on h.country](https://github.com/harmony-one/h.country/pull/99): Updated the h.country menu option logic, setting the filter mode to 'All'; updated the selection logic of actions' from/to address, adding the updated page address to the action filter and changing the filter mode to 'address.'

2024-02-26 Mon: Worked on the following [tasks on h.country](https://github.com/harmony-one/h.country/pull/96): Updated the check-in message display logic. There is an issue with some check-in action messages (when syncUserLocation) that were unable to get the location address information, showing an empty message. For those cases, we can try to fetch the information again (calling the nomination API again), and with a second not successful operation, simply not store the check-in on Firebase. Updated the UserPage action filter look and fee. Added onClick logic to the h.country menu option; when clicked, it navigates to the UserPage with no active filters.

---
2024-02-25 Sun: Worked on the following [tasks on h.country](https://github.com/harmony-one/h.country/pull/90): Fixed [object][object] rendering on check-in action messages; fixed runtime error on intersection observer; added Firebase doc's ID to Action Type to set a unique key to every UserAction component to avoid continuing rendering. 

2024-02-24 Sat: Worked on the following [tasks on h.country](https://github.com/harmony-one/h.country/pull/89): Added user's emoji reaction to action messages; added lazy load and intersection observer to handle action list rendering. Also, I worked on [Harmony1Bot](https://github.com/harmony-one/HarmonyOneBot/pull/353), where I fixed suffix issues and added one inquiry limitation per image on each chat.

2024-02-23 Fri: Worked on the fowolling [tasks on h.country](https://github.com/harmony-one/h.country/pull/71): Disable scroll horizontally on mobile; make text on the selection page (/hash) bigger; limit 10 chars for a tag, and locations in the hashtag section; limit 15 chars for the tag on message section; fix slash and hashtag icon; remove new user self-tagging; fixed location action message overlap; updated URL char truncation; added geolocation after the third topic selected on the welcome page; fixed menu address rendering.

2024-02-22 Thu: Worked on the fowolling [tasks on h.country](https://github.com/harmony-one/h.country/pull/71): Updated action type (self/other) color logic; updated /new route logic and fixed double wallet creation; fixed font styling (grey color and size); fixed manual topic selection tag type logic; update Grommet theme and styled component styling. Also worked on [SocialMap app](https://github.com/harmony-one/1/pull/8), finishing the following tasks: updated footer styling and marker callout styling. 

2024-02-21 Wed: Worked on the fowolling [tasks on h.country](https://github.com/harmony-one/h.country/pull/55): Updated UserPage styling; fixed tags and URL logos cut off and added isUserPage logic; updated filter panel styling and added #one and @ai filter logic; added a topic selection limit on the welcome page; added rendering logic on the welcome page when the topic query param is set.

2024-02-20 Tue: Worked on the following [tasks on h.country](https://github.com/harmony-one/h.country/pull/37): Fixed multiple wallet creation after topic selection on the hash route component, which affects actions rendering on the UserPage component. Updated the UserPage route component styling, including the messages section, texts, and styling when no address is set. Updated /hash look and feel and topic list. Updated recurrent user logic on topic selection. Fixed issues when no topic query param is on /hash route. Update redirect logic for new users to /hash route component.

2024-02-19 Mon: Worked on [h.country](https://github.com/harmony-one/h.country/pull/22). Changed the number of topics to select from 4 to 3. Added logic that creates a Tag Action for each selected topic and a Tag Action from the user to himself. Updated slash and hash colors: blue for himself and yellow for others. Pending green for verified type. Updated HeaderList component to show a 3 x 3 grid of tags in order by frequency. 

---
2024-02-16 Fri: Fixed [dark theme logos rendering](https://github.com/harmony-one/h.country/pull/12), and added meta tag logic. Added dark/light theme logic, but leave dark theme on by default. Fixed mobile full screen redering. 

2024-02-15 Thu: Keep working on the [Human Protocol](https://github.com/harmony-one/human-protocol/pull/20) user interface, updating the welcome page look and feel. Refactored Topic's logo prefetch logic. Added the Nunito font and updated the Welcome and Messages route component's styling.

2024-02-14 Wed: Worked on user interface improvements for the [Human Protocol](https://github.com/harmony-one/human-protocol/pull/18) project. Updated the Welcome route component by adding and grouping topics, changing topic container look and feel, and isSelected logic. 

2024-02-13 Tue: Worked on fixing the [Whisper demo](https://github.com/harmony-one/web-whisper.demo) to make it compatible with Chrome and Safari for mobile by updating codec handling for Safari and audio chunks logic. Here is a working [demo](https://webpage-whisper-demo.fly.dev/).  

2024-02-12 Mon: Worked on the [Whisper demo](https://github.com/harmony-one/web-whisper.demo) on React. Finished the first version of the WebApp that records voice memos and uses Openai's Whisper model to transcribe the audio. Also, added a Web Speech API transcribe option.

---
2024-02-09 Fri: [Refacored SocialMap app](https://github.com/harmony-one/1/pull/7), added the src folder modularizing components, updated the markers interface and logic, and added the Posts component.

2024-02-08 Thu: Finished the API call to the [whisper endpoint](https://github.com/harmony-one/1/pull/5). Fixed multi-voice memo recording issue and updated the code logic from expo to react-native CLI.

2024-02-07 Wed: Worked on the whisper endpoint on [harmony-llm-api](https://github.com/harmony-one/harmony-llm-api/pull/12) backend and API call on the [SocialMap app](https://github.com/harmony-one/1/pull/3). Added [markers API](https://github.com/harmony-one/1/pull/2). 

2024-02-06 Tue: Worked briefly on a Farcaster project. Reviewed the best way to implement a [Farcaster Hub](https://docs.farcaster.xyz/developers/) (like an Ethereum node), which is required to create apps on top of Farcaster and started working on a social map app on react-native.

2024-02-05 Mon: Started briefly working on v.country, a website that records and transcribes voice memos using Openai's Whisper modal. Started working on a [Farcaster](https://docs.farcaster.xyz/) implementation. 

----
2024-02-02 Fri: Added censorship check to dalle text and voice command and included content_policy_violation for [openAI](https://github.com/harmony-one/HarmonyOneBot/pull/353) errors. Also, added refund handling on openAIs and voiceCommand bots. Finally, disabled the inscription lottery.

2024-02-01 Thu: Updated Inscription payload to include user info (username, walletAddress); also added logic to delete the [share button](https://github.com/harmony-one/HarmonyOneBot/pull/353) after a successful Inscription. Updated [dot country](https://github.com/harmony-one/1-country.frontend/pull/216) to work with new inscription payload to hide Telegram's bot token. 

2024-01-31 Wed: Finished 1.country rendering of Telegram/Image subscription on [dot country](https://github.com/harmony-one/1-country.frontend/pull/216). Update [Inscription call data](https://github.com/harmony-one/HarmonyOneBot/pull/353) and fix prefix issues with Dalle and Stable Diffusion.

2024-01-30 Tue: Finished [inscription logic](https://github.com/harmony-one/HarmonyOneBot/pull/353) and progess messaging handling for image and prompt inscription on Harmony1Bot. Also, worked on 1.country with the [Telegram's inscription integration](https://github.com/harmony-one/1-country.frontend/pull/216).

2024-01-29 Mon: Worked on integrating [Inscription logic on Harmony1Bot](https://github.com/harmony-one/HarmonyOneBot/pull/353). Created the share button and 0-cost transaction with call data and added initial logic. 

----
2024-01-26 Fri: Cleaned the [prompt-generated text](https://github.com/harmony-one/HarmonyOneBot/pull/351/commits/949701af242848e65990691eef4b73499df433c8) on voice command and updated voice command duration up to 30 seconds. Added a [share button](https://github.com/harmony-one/HarmonyOneBot/pull/353) to Dalle's generated images for inscription logic. 

2024-01-25 Thu: Added payment logic for whisper on voice-command services. [Improved user experience](https://github.com/harmony-one/HarmonyOneBot/pull/351) by adding voice command reuse to avoid the user repeating the command on each interaction. Updated the conversation queue to store the output format (voice, text) and msgId (to replace the progress message with the completion).   

2024-01-24 Wed: Added the [image (dalle) and talk command](https://github.com/harmony-one/HarmonyOneBot/pull/351) to the voice-command bot. For dalle, the user has to send a voice note starting with the command image and then the prompt. When a user sends a voice note with the command talk, the AI completion returns as a voice note.

2024-01-23 Tue: Updated the payment logic for pdf/URL web crawling services. Added [voice-command](https://github.com/harmony-one/HarmonyOneBot/pull/351) functionality for chat GPT and vision features. With voice command, the user sends a voice note starting with the command ('ask' for chat GPT, 'vision' for vision) with the prompt, and the bot generates the completion. For Vision, the voice note has to be a reply to an image. 

2024-01-22 Mon: Fixed [payment issues](https://github.com/harmony-one/HarmonyOneBot/pull/350) with dalle and Chat GPT commands. The app was storing the token and price usage for the conversation but was not using the token usage information to calculate the input token price. The new DALLE 3 implementation requires the price to be handled as cents.

----
2024-01-19 Fri: Worked on fixing whitelist issues and payment issues. Fixed [whitelist issues](https://github.com/harmony-one/HarmonyOneBot/pull/350) with private chats and the updated whitelist environment variable. Checked the implementation of whisper on Harmony1Bot. 

2024-01-18 Thu: Fixed new command prefix error when the new prompt was empty. Refactored command handling on openAi, llms, and 1Country. Added [vision completion context](https://github.com/harmony-one/HarmonyOneBot/pull/350) to provide complete responses within a 100-word limit

2024-01-17 Wed: Fixed prompts with a [code snippets](https://github.com/harmony-one/HarmonyOneBot/pull/350) that were handled as URLs and produced an error messages. Fixed an error with vision calls on group chat by requiring vision command on images reply.

2024-01-16 Tue: Added streaming completion to [vision logic](https://github.com/harmony-one/HarmonyOneBot/pull/348). Also, added /vision command that allows the user to inquire about multiple image URLs. Didn't add vision prompts/completions to the bot conversation because it uses different models, and the content key of the body parameter has a different scheme. 

2024-01-15 Mon: Worked on [deleting prefixes with familiar words](https://github.com/harmony-one/HarmonyOneBot/pull/349) to increase user experience; the removed words were 'am', 'be', 'ny', 'ha', 'no' from Translate bot.  [Deployed Vision on Harmony1Bot](https://github.com/harmony-one/HarmonyOneBot/pull/348) as a chatCompletion, not as a part of a conversation, due to a different JSON scheme for the content key. On Tuesday, will work on including in the bot conversation the vision's prompt and completion. Also, will add chunk prompting (stream) and /vision command where the user can send an image URL with a prompt.

---

2024-01-12 Fri: Started working on Vision integration. Fixed [i prefix](https://github.com/harmony-one/HarmonyOneBot/pull/347) bug. 

2024-01-11 Thu: Updated [allstats and stats reports](https://github.com/harmony-one/HarmonyOneBot/pull/346) including one-time users. Added [/i command](https://github.com/harmony-one/HarmonyOneBot/pull/345) to dalle-3.

2024-01-10 Wed: Added and updated weekly and total KPIs to the [stats report](https://github.com/harmony-one/HarmonyOneBot/pull/346), working on adding new users report. Worked on adding images command to dalle-3.

2024-01-09 Tue: Added prefixes and commands to the [dalle-3 logic](https://github.com/harmony-one/HarmonyOneBot/pull/345) and updated the SD image logic. Checked the inconsistencies reported on the bot stats report.

2024-01-08 Mon: Integrated [Dalle-3](https://github.com/harmony-one/HarmonyOneBot/pull/345) to Harmony1Bot with session image generation queue and message status.

---
2023-12-25 Mon - 2024-01-05 Fri: Paid time off.

---
2023-12-22 Fri: Added speech recognition (speech-to-text) to [voiceOn prototype](https://github.com/harmony-one/x/pull/412), and worked on [llms endpoint](https://github.com/harmony-one/harmony-llm-api/pull/11). Deployed to HarmontOneBot dev /alias /aliases command implementation.  

2023-12-21 Thu: Sergey and Yuriy help fix local deployment issues of [layer zero bridge](https://github.com/harmony-one/layerzero-bridge.frontend/pull/22). Added [add document endpoint](https://github.com/harmony-one/harmony-llm-api/pull/11) on the llms backend for the VoiceOn prototype. Found a local on-device vector database for [Swift Apps](https://github.com/Dripfarm/SVDB) to be tested for the VoiceOn prototype. Worked on [alias/aliases command](https://github.com/harmony-one/HarmonyOneBot/pull/344) for HarmonyOneBot. 

2023-12-20 Wed: Working on fixing issues with the configuration of the local development environment for layer zero bridge look and feel updates. Configured local development environment for VoiceOn prototype.

2023-12-19 Tue: Started working on [VoiceOn prototype](https://github.com/harmony-one/x/tree/main/voice/x.on), exploring Chromadb embeddings for voice transcript. Also started working on the [bridge styling](https://bridge.harmony.one/erc20) update. Supported 1.country with a domain registration issue.

2023-12-18 Mon: Worked on [AppConfig unit tests](https://github.com/harmony-one/x/pull/404), reaching 90% coverage. Had to create the RelayAuth protocol to enable RelayAuth dependency injection for unit tests.

----
2023-12-15 Fri: Worked on unit tests for [DataFeed class](https://github.com/harmony-one/x/pull/394/) after new refactoring, reaching 98,9% coverage. Also, worked on [AppConfig unit tests](https://github.com/harmony-one/x/pull/396) reaching 84.9% coverage. 

2023-12-14 Thu: Worked on [AppConfig unit tests](https://github.com/harmony-one/x/pull/388). For unit testing, refactored init and loadConfiguration functions and added an extension to help access private methods, waiting on review after AppConfig refactoring. Finally, started working on updating the DataFeed unit tests after the latest DataFeed refactoring.  

2023-12-13 Wed: Worked on unit tests for [DataFeed](https://github.com/harmony-one/x/pull/374) and reached 99% coverage. Had to redo the unit test due to Data Feed refactoring, getting back to 99% coverage. Worked on the ActivityView unit test and had issues creating a MockContext to test the makeUIViewController function. 


2023-12-12 Tue: Added unit tests for [DataFeed](https://github.com/harmony-one/x/pull/370), [TriviaManager](https://github.com/harmony-one/x/pull/355) and ActivityView. Fixed [isSharing](https://github.com/harmony-one/x/pull/361) issues on unit tests build after refactoring.  

2023-12-11 Mon: Fixed build issues on [unit tests](https://github.com/harmony-one/x/pull/344) after OpenAI refactoring. Updated TextToSpeechConverterTests and OpenAIServiceTests unit tests. Also, added trivia ActionType unit tests. Added trivia context to string Catalog. Had issues with AppleSignInManagerTests, but I am still working on it.

---
2023-12-08 Fri: Fixed AppleTests, NetworkManagerTests, and UserTest [unit tests](https://github.com/harmony-one/x/pull/335) after KeychainService class refactoring, also update CreateUser struc adding memberwise initializer initializer. Added [unit tests](https://github.com/harmony-one/x/pull/339) for the ActionsView struct and UserAPI class. 

2023-12-07 Thu: Worked on unit tests for the Voice AI project. Improved unit tests of [AppleSignInManager class](https://github.com/harmony-one/x/pull/330). 

2023-12-06 Wed: Added Custom Instructions, Shortcode Intents and speech recognition texts to [string catalogs](https://github.com/harmony-one/x/pull/318). Worked on UserAPI [unit tests](https://github.com/harmony-one/x/pull/324). Added Custom Modes [trigger logic](https://github.com/harmony-one/x/pull/325) for Voice AI Settings. Also, worked on HarmonyOneBot issues with text-to-voice and translation commands.     

2023-12-05 Tue: Researched language localization for iOS Swift. Finally, implemented a [String Catalog](https://github.com/harmony-one/x/pull/318/) to handle language localization in a single file location. Still need to figure out what to do with the texts-related function on the Texts folder. 

2023-12-04 Mon: Finished working on [Custom Instructions View](https://github.com/harmony-one/x/pull/299). Solved user experience and styling issues, updated the logic to move the user's custom instruction input to System Settings and left Default, Quick Facts, and Interactive Tutor logic on the View. Finally, reverted [Custom Instruction View Unit Test PR](https://github.com/harmony-one/x/pull/305), manually [reverted Custom Instruction View PR](https://github.com/harmony-one/x/pull/308) and updated the More Actions menu.

---
2023-12-01 Fri: Worked on fuzz test research. Also, worked on [Custom Instructions View](https://github.com/harmony-one/x/pull/299). Users can choose between Interactive Tour, Quick Facts, Default Context, or Custom on an Active Sheet look-like view. On Monday, I will work on styling issues and User Interface behavior. 

2023-11-30 Thu: Changed review [requester logic](https://github.com/harmony-one/x/commit/00c11beced436602f8d3a99b2d6c8cb1a4774b5e) for new session button action. Also, I have started to research fuzz testing for swift projects. There are not up to date tools on the market.

2023-11-29 Wed: The PR review showed issues with published attributes that handle button actions, malfunctioning the app. [Fixed](https://github.com/harmony-one/x/pull/255) property published issues, refactored ActionsViewProtocol, ActionsView struct, and MockActionsView class.  

2023-11-28 Tue: Worked on unit tests for [ActionsView struct](https://github.com/harmony-one/x/pull/255): adding reset, play, openSettings, and closures unit tests. Fixed merge issues with the main branch after ActionsView refactoring. The PR is currently in review. 

2023-11-27 Mon: Fixed unit test errors on [AppleTest](https://github.com/harmony-one/x/pull/274) and ActionsViewTests. Added lastButtonPressed, showInAppPurchase [unit tests](https://github.com/harmony-one/x/pull/270) on ActionViewTest (67%). 

---
2023-11-24 Fri: Fixed unit tests build errors on OpenAIModelsTets, AppConfigurationTests, and SettingsBundleHelper class. Added [Unit Tests](https://github.com/harmony-one/x/pull/260) for ThemeManager (100%), ActionsView (65%), UserApi (55%).

2023-11-23 Thu: Refactored Actions View to add ActionHandler [dependency injection](https://github.com/harmony-one/x/pull/255) to ease unit testing. The changes include creating ActionHandler Protocol and ActionHandlerMock class.

2023-11-22 Wed: Fixed premium expiration date format for [settings bundle](https://github.com/harmony-one/x/pull/243). Keep working on ActionsView [unit tests](https://github.com/harmony-one/x/pull/253), and updated test logic after ButtonData attributes changed. 

2023-11-21 Tue: [Joined configuration files](https://github.com/harmony-one/x/pull/241) of target x and target Sun. Now, all shared media will be handled in x\AssetsShared.xcassets file, while each discting media (like the app logo) will be governed by x\Assets.xcassets and Sun\AssetsShared.xcassets. Also, both targets will share the configuration data with x\Info_shared.plist file. Finally, removed the date's seconds value on the premium expiration date and kept working on Unit tests for ActionsView. 

2023-11-20 Mon: Added [local time](https://github.com/harmony-one/x/pull/234) for System Settings and changed custom instruction label and fixed alignment. Worked with Rikako and Nagesh on unit tests and made some updates on ActionsView unit tests (the coverage % will be updated later today). Worked on Store ObservableObject error while running Unit tests. 

---
2023-11-17 Fri: Reviewed removed [rate limit PR](https://github.com/harmony-one/x/pull/199/), Also, added logic for multiple user taps on [Surprise button](https://github.com/harmony-one/x/pull/223) (waiting on review), adding a 0.5 seconds buffer to disable double tap, and after that new request will kill the previous one. Added [Unit Tests](https://github.com/harmony-one/x/pull/199/) for ActionsView (71%), UserAPI (52%).

2023-11-16 Thu: [Optimized mic initialization](https://github.com/harmony-one/x/pull/207) (audioSession/audioEngine) reducing lagging and user words dropping (first words sometimes were missed). Updated UI for [system settings](https://github.com/harmony-one/x/pull/208) (aligning). Worked on [Unit test](https://github.com/harmony-one/x/pull/199) for Actions View.

2023-11-15 Wed: Added [user review request logic](https://github.com/harmony-one/x/pull/193) when the user presses the new session button and the following conditions occur: pressed the button for 10th times and a random function that adds 25% probability returns true. Each time the user reaches the 10th click, the counter resets. With the help of Nagesh fixed issues in my unit test environment, allowing me to work on [ActionsView unit tests](https://github.com/harmony-one/x/pull/199). Created a new OpenAI API Key for Harmony1Bot and updated and tested the new key on the Bot and on the llm-API backend.

2023-11-14 Tue: Fixed custom instructions logic that was not resetting the conversation after custom instructions changes and fixed custom instruction duplicity. Also, fixed pause/play icon responsiveness due to a 1-second delay after the user presses the pause button.

2023-11-13 Mon: Worked on [custom instructions logic](https://github.com/harmony-one/x/pull/179) enabling the user to change the conversation context. Created app settings to store conversation context and added a Reset toggle switch to reset custom instructions to the default message. One thing to consider with the app settings is that it doesn't have a button (to replace the Reset toggle switch), and the input text field is too short for the default custom instruction text. Also, update the app font to [Dotrice Bold](https://github.com/harmony-one/x/pull/184).

---
2023-11-10 Fri: Fixed _required condition is false: IsFormatSampleRateAndChannelCountValid(format)_, added Persistence and OpenAIResponse [unit tests](https://github.com/harmony-one/x/pull/160), and Speech Recognition [unit tests](https://github.com/harmony-one/x/pull/167)   

2023-11-9 Thu: Added [unit tests](https://github.com/harmony-one/x/pull/156) for ActionHandler and AppConfig classes.

2023-11-8 Wed: Added unit tests for [getTitle](https://github.com/harmony-one/x/pull/150) (surprise Action type), Message model, and added reset and surprise action handler [unit tests](https://github.com/harmony-one/x/pull/151).

2023-11-7 Tue: Added press/hold button logic and updated say more button on [blackred Theme](https://github.com/harmony-one/x/pull/128). Finished [theme logic](Tue: https://github.com/harmony-one/x/pull/124) to ease look and feel testing. The logic includes press/hold effects for buttons, icons, and labels.

2023-11-6 Mon: Worked on play/pause transition after [button pressed](https://github.com/harmony-one/x/pull/126) and also worked on the new [red/black look and feel design](https://github.com/harmony-one/x/pull/128) and pressed/unpressed logic due to button transition and adding new foreground colors.  

---
2023-11-3 Fri: Added basic [theme logic](https://github.com/harmony-one/x/pull/124/) to help look and feel color changes. This PR adds nothing to the phone's layout because it takes the theme from AppConfig.plist. The theme changes can occur by voice commands from the user.   

2023-11-2 Thu: Worked on the user interface [look and feel](https://github.com/harmony-one/x/pull/124/commits/fac6e12cfd884974c4947fd89269ce9df6805f6e), testing new Figma designs.

2023-11-1 Wed: Fixed group whitelist and image issues (the later with the help of Yuriy) on Harmony1Bot. Updated [Voice AI context](https://github.com/harmony-one/x/pull/89), including directives, also updated Wikipedia prompt.

2023-10-31 Tue: Created unit test for Context and messages for [OpeanAIStreaming service](https://github.com/harmony-one/x/pull/102). Check group admin/owner whitelist issues and /image issues on HarmonyOneBot. 

2023-10-30 Mon: Change home grid button spacing and font size to match Figma design. Added custom instructions to message context. Update context and custom instructions to streaming functionality. Started working on the unit tests for OpenAiService module
(Implement unit testing for - OpenAiService (Context) & OpenAiService (Streaming))

---
2023-10-27 Fri: Added conversation context and updated user interface on [Voice AI app](https://github.com/harmony-one/x/pull/83). Worked on fixing harmony1Bot /vkom command.

2023-10-26 Thu: Fix conversation history issues and merge to the main branch. Fixed mobile testing issues. Update Hey Frank to the latest app version. Started working on improving audio streaming on Hey Frank

2023-10-25 Wed: Implemented conversation history for [iOS app](https://github.com/harmony-one/x/pull/70/). Had issues testing it on my mobile (working on fixing it).

2023-10-24 Tue: Merged subscription logic to master branch on [stripe-payments-backend](https://github.com/harmony-one/stripe-payments-backend/pull/4). Added subscription status logic on the Discord bot. Deployed Hey Frank ios app. 

2023-10-23 Mon: Added subscription handling on [Discord bot](https://github.com/harmony-one/harmony-discord-bot/pull/1) and [stripe backend](https://github.com/harmony-one/stripe-payments-backend/pull/4). Regarding 1bot development, the top 3 tasks are as follows: 1) Finish fiat payment on Discord bot (16h), 2) Upgrade voice transcription/summary using llama-index vector database to improve summary and allow the user to inquire about the voice transcript (12h), 3) Implement Dalle 3 when available (10h), 4) (optional) Migrate ChromaDB (vector database) to the hosted solution when available (4h).

---

2023-10-20 Fri: Keep working on fiat payment for the Discord bot in a [subscription model using stripe](https://github.com/harmony-one/stripe-payments-backend/pull/4)

2023-10-19 Thu: Keep working on fiat payment for the Discord bot. Added customer creation to the user/create endpoint. Added user/guild (server) logic on discord bot.

2023-10-18 Wed: Added [group whitelist handling](https://github.com/harmony-one/HarmonyOneBot/pull/342) for HarmonyBot. When a user of the whitelist is the owner or an admin of a group, that group is whitelisted. Keep working on fiat payment for the discord bot, integrating the payment functionality to the existing stripe-payment-backend, and defining the architecture of the image subscribing model for discord users.  

2023-10-17 Tue: Added * prefix/alias for handling inquiries to the [current context (URLs/pdf)](https://github.com/harmony-one/HarmonyOneBot/pull/341). * alias works along /ctx command. Fixed /pdf issues after merging to the master branch. Made changes to the conversation array for llama-index inquiries. Worked on stripe payments backend for discord bot.  

2023-10-16 Mon: Deployed and integrated harmony-llm-api to harmony1Bot. Refactored discord bot, adding command cogs (image and payment), error handling, and basic balance logic. [harmony-discord-bot](https://github.com/harmony-one/harmony-discord-bot). 

---

2023-10-13 Fri: Deployed a hosted Chromadb server for the production environment and fixed collection storage issues for document (URL/PDF) inquiries. Keep working on the discord bot. 

2023-10-12 Thu: Fixed dependencies issues with [harmony-llm-api-dev server](https://github.com/harmony-one/harmony-llm-api/pull/10). The server has llama-index required improvements. The improvements will be tested and published in the production environment on Friday morning. Started working on the discord bot to allow fiat payments.

2023-10-11 Wed: Fixed PDF/URL automatic processing on group chats. Added URL invalid handling. Deployed dev server for llm-api backend.

2023-10-10 Tue: Added gpt-3.5-turbo to llama-index collection handling. Also, added PDF invalid handling and improved completion error handling. Fixed the flyio deployment issue that keeps restarting the server [in review](https://github.com/harmony-one/harmony-llm-api/pull/10). 

2023-10-09 Mon: Added completion message length error handling [complete](https://github.com/harmony-one/HarmonyOneBot/pull/337). Added 5 min processing time to PDF and URL collection processing to avoid unlimited requests to the backend [in review](https://github.com/harmony-one/HarmonyOneBot/pull/338).
