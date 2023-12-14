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
