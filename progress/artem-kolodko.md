2024-01-18 Thu: [Added](https://github.com/harmony-one/inscription.indexer/pull/1/files) database entities in inscription indexer, configured indexer state table and saving inscriptions into Postgres database.

2024-01-17 Wed: Learning inscription [indexer](https://github.com/harmony-one/inscription.indexer) codebase, started working on storing inscriptions in database.

2024-01-16 Tue: Completed address limiter, created [PR #11](https://github.com/harmony-one/s/pull/11).

2024-01-15 Mon: [added](https://github.com/harmony-one/s/pull/11/commits/5be853b5260ac34ccbff38a0bbbff0949ce0fc0d) executed status to completed transactons. Started working on limits by user address by hour.

---

2024-01-12 Fri: working on transfer amount limiter. Added new DB table to store pending transactions. Completed first version of transfer limiter, started testing.

2024-01-11 Thu: sick day-off

2024-01-10 Wed: sick day-off

2024-01-09 Tue: synced with devs about new moe project, started working on rate limiter

2024-01-08 Mon: reviewed [moe](https://github.com/harmony-one/s/tree/main/moe) repository code, sent review with couple of notes to Sun. Researching [moe](https://harmony.one/moe).

---

2023-12-25 Mon - 2024-01-05 Fri: Paid time off.

---

2023-12-22 Fri: [added](https://github.com/harmony-one/x/commit/122b33cddb97914f1b383a90209b229fd9ead688) in-memory cache to x-api backend endpoints

2023-12-21 Thu: [Added](https://github.com/harmony-one/x/pull/411) progressView tests, researched new [inscription](https://github.com/harmony-one/1country-inscription) project, discussed  inscription indexer architecture with Yuriy.

2023-12-20 Wed: Twitter API service: [update](https://github.com/harmony-one/x/commit/55a9ed1aabe8249fd3110f7613a746b5ea9009ce) new Twitter list on create; added default rate limiter. Check current state of X app unit tests.

2023-12-19 Tue: [updated](https://github.com/harmony-one/x/commit/aba84ba598be94706bddec0ed9f8ef50f49ddd24) x-api backend: added params to GET /list, improved delete and update twitter list endpoints. [Added](https://github.com/harmony-one/explorer-v2-frontend/pull/285) total undelegated info to Staked dropdown in Harmony Explorer (from Aaron).

2023-12-18 Mon: [reviewed](https://github.com/harmony-one/x/pull/399) Twitter lists PR from Yuriy. [Refactored](https://github.com/harmony-one/x/commit/cce850cf8681b38c508323c361ebab97726aa81a) Twitter lists: removed separate module and controller, improved /update endpoint. [Added](https://github.com/harmony-one/explorer-v2-frontend/commit/1924e42975d8218b298635705f2808ac16754b8f) undelegation info to Staking tab in Explorer client (request from Aaron).

---

2023-12-15 Fri: [implemented](https://github.com/harmony-one/x/commit/9d9206930f30b369aea65809a1e54a2893dbf684) endpoints getListByName and getLists in x-api backend service, configured twitter Lists as described [here](https://github.com/harmony-one/x/blob/main/doc/follows). Tweets from the lists are updated every 30 minutes and can be used to provide additional context to ChatGPT. [Deployed](https://x-api-backend.fly.dev/api#/) x-api backend.

2023-12-14 Thu: [added](https://github.com/harmony-one/x/commit/81289e0fb5fed1131d8a7802306452dcd26a4270) database table to store a list of tweets for each topic, implemented a cron job to update this list in our database every 30 minutes. Tested with real Twitter API.

2023-12-13 Wed: [added](https://github.com/harmony-one/x/commit/67cdd4a7845e5a2476f2a4c24b0c5244b605de6d) basic implementation of twitter list endpoint in x-api backend; working on database schema. 

2023-12-12 Tue: synced with Sun and Yuriy about new [twitter-api](https://github.com/harmony-one/x/pull/342/files) project; [started](https://github.com/harmony-one/x/tree/main/backend/x-api) working on backend app, implemented basic features :project structure, configuration, database, Swagger API.

2023-12-11 Mon: researched Aaron's [docs](https://github.com/harmony-one/x/pull/342/files) on X (twitter) API, prepared for the call with Sun. [Added](https://github.com/harmony-one/x-payments-backend/commit/0957b6373d7052d2f11c16769703889e8b1fa28f) new endpoint `GET /users` to X app backend.

---

2023-12-08 Fri: [Added](https://github.com/harmony-one/x-payments-backend/pull/8) blockchain address associated with appleId in Payments backend, added DB migration. [Fixed](https://github.com/harmony-one/x/pull/333) exporting logs to Notes app, changed logs order.

2023-12-07 Thu: completed logs refactoring: added custom logger to ActionHandler, RelayAuth, AppleSignInManager, TextToSpeechConverter, and more classes. Added formatted timestamp to logs export. [PR#309](https://github.com/harmony-one/x/pull/319) is merged into main branch.

2023-12-06 Wed: working on exporting logs: implemented custom logs system, added export, started refactoring current logs to a new logger. Updated ActionsView, SettingsView, SpeechRecognition classes, working on the rest app. PR [#309](https://github.com/harmony-one/x/pull/319).

2023-12-05 Tue: [added](https://github.com/harmony-one/x/commit/bf0e2df0821493b9ffd543404846f8a67c350023) app version alert: if the app version is lower than the version from the App Store, the user will see a notification prompting to update the app.

2023-12-04 Mon: [added](https://github.com/harmony-one/x/pull/301) user appVersion field in iOS app; update appVersion on app init

---

2023-12-01 Fri: [added](https://github.com/harmony-one/x/commit/92b91981e0981a10538dc3081be7f2dd28ceca02) new appVersion and isSubscriber fields to user account; tested VoiceAI app. [Updated](https://github.com/harmony-one/x-payments-backend/commit/36de1a1a13f15f455365712d443ddd5c8523fce7) Payments api typings.

2023-11-30 Thu: [added](https://github.com/harmony-one/x-payments-backend/commit/5cb2a46900171b8fd05c2c833ffd4f1416a7982c) appVersion to user account in VoiceAI payments service, implemented new endpoint `/users/update`.

2023-11-29 Wed: Updated [backend](https://x-payments-api.fly.dev/api) to support production in-App Purchase handling; [launched](https://x-payments-api-sandbox.fly.dev/api) second backend instance to support sandbox in-App purchases for TestFlight build. Working on adding app version control in user account on backend side (request from Nagesh).

2023-11-28 Tue: started working on SettingsView unit tests, [PR#281](https://github.com/harmony-one/x/pull/281/files)

2023-11-27 Mon: [Updated](https://github.com/harmony-one/x/pull/271) user properties, added `isSubscriptionActive` field from Payments backend response to check is user subscribed, updated user API test.

---

2023-11-24 Fri: Fixed test in [PR#247](https://github.com/harmony-one/x/pull/247), merged. [Refactored](https://github.com/harmony-one/x/pull/266) repeatButton type, refactored Action button tests, improved SettingsView test.

2023-11-23 Thu: [measured](https://github.com/harmony-one/x/pull/252) relayer first response latency, average value is around 1.2 seconds until first response. [Added](https://github.com/harmony-one/stripe-payments-backend/commit/60778134b93620f52bbd8bba103917974f410d76) isSubscriptionActive field to user account in Payment service.

2023-11-22 Wed: [added](https://github.com/harmony-one/x/pull/247) UI test for Settings modal, fixed actions buttons test; working on relay service latency measurements.

2023-11-21 Tue: worked on Settings modal: fixed black overlay issue, fixed close settings handler, updated link to a new "Voice AI: Super-Intelligence" app in Share button, added Tweet. Pushed al changes into `dev_1.1120.9` branch, PR [#225](https://github.com/harmony-one/x/pull/225).

2023-11-20 Mon: [helped](https://github.com/harmony-one/explorer-v2-frontend/pull/283) Aaron to track Explorer visits for specific address pages, configured Google Tag Manager and Fingerprint.com. [Implemented](https://github.com/harmony-one/x/pull/221) Settings modal with 3 buttons in VoiceAI, created PR.

---

2023-11-17 Fri: [updated](https://github.com/harmony-one/stripe-payments-backend/commit/58b217da44a6c5ee41d64a70cc81cf4878f2dd1c) productId to "com.country.x.purchase.3day", [refactored API](https://github.com/harmony-one/stripe-payments-backend/commit/ffa4b5c40139bc35db1600bcd3581471e1043ea2), deployed [update](https://x-payments-api.fly.dev/api).

2023-11-16 Thu: [added](https://github.com/harmony-one/stripe-payments-backend/commit/0084a613108cffd0aa1cea855ed81e022fd82585) a new field to user account: expirationDate; this field is updated when a 3-day subscription is purchased and is used to determine if the user currently has a subscription. [Added](https://github.com/harmony-one/stripe-payments-backend/commit/3bc72662f19c925d350422ef3291e0dca0f2afa0) new endpoint for deleting user account (required API_KEY to use), renamed /withdraw to /spend, improved logs.

2023-11-15 Wed: [check](https://github.com/harmony-one/stripe-payments-backend/commit/31b71c5ad4fd0a6d09a1b33fd62d0eda05c91b8d) uniqueness of transactionId identifier, add API key guard for /purchases and /spend endpoints, added production App Store enviroment support, improved logging

2023-11-14 Tue: [added](https://github.com/harmony-one/stripe-payments-backend/commit/39d28353696a0fb8c59a786fdeed70edfc1970d9) new product support on Payments service side; now the amount of credits purchased by a user is calculated based on productId. [Deployed](https://x-payments-api.fly.dev/api) payments service update to integrate it with VoiceAI app. Working on authorization guard for /users/withdraw endpoint.

2023-11-13 Mon: [added](https://github.com/harmony-one/stripe-payments-backend/commit/0d85b4c137a707168837cc690630998c1d211f67) tokensAmount param to /withdraw endpoint; credits amount to withdraw will be calculated on Payments backend side based on tokensAmount and configuration params. Added `withdrawals` database table to store all withdraw requests and user credits balance data (before and after transaction).

---

2023-11-10 Fri: [added](https://github.com/harmony-one/stripe-payments-backend/pull/6/commits/c530d2ffb2156301afbb8fef815e6797259bb47f) integration with AppStore API to get payment transaction (and credits amount by productId) by transactionId from iOS app. Added purchases database table with list of all in-app purchases. [Implemented](https://github.com/harmony-one/stripe-payments-backend/pull/6/commits/7f099cb5eec711233bab97fa63b7a3066c5fb628) endpoint to get all user purchases. [Deployed](https://x-payments-api.fly.dev/api#/) Payments service with latest updates.

2023-11-09 Thu: [added](https://github.com/harmony-one/stripe-payments-backend/pull/6/commits/568088f801558bc5d558439eda205b8a762e12d3) authorization guard in Payments backend, [implemented](https://github.com/harmony-one/stripe-payments-backend/pull/6/commits/dfb73ec94f2d765bef0c31e43c8d0b2cc0bf47e0) new method to get transactionId after successful purchase and [linking](https://github.com/harmony-one/stripe-payments-backend/pull/6/commits/53aa54eef40e26e171363ab991fe184c92c8b601) appleId to existed account after SignIn. [Updated](https://x-payments-api.fly.dev/api) Payments service.

2023-11-08 Wed: [added](https://github.com/harmony-one/stripe-payments-backend/pull/6/commits/011bb24f59b46c88a58866b4fc6832f373f8537d) new endpoints to Payments service after conversation with Nagesh and Theo F: create user, get user balance, pay (only for test purposes) and withdraw. Deployed [Payments service](https://x-payments-api.fly.dev/api), shared all information with Nagesh and Theo. Continue working on JWT guard on Payments service side.


2023-11-07 Tue: [implemented](https://github.com/harmony-one/stripe-payments-backend/pull/6/commits) endpoints on Payments backend side to create a new user, associated with AppleId, drafted architecture and payments flow, discussed details with Nagesh and Theo F (free credits, tokens refill, JWT authorization). Started working on JWT authorization on payments backend side.

2023-11-06 Mon: switched VoiceAI to Simple Rules, added synced Products list, published new version in TestFlight ([PR #121](https://github.com/harmony-one/x/commit/bbad4869b9e1cd67fa60c2c21f17eb2caaf58884)). Now in-app purchases working in TestFlight build! Started implementing logging for TestFlight build, we will need logs to get originalTransactionId and listen for transaction history in payments backend (limitation from AppStore API).

---

2023-11-03 Fri: started working on in-app purchase tracking: researched AppStore API basic methods, transactions structure, [created](https://github.com/harmony-one/stripe-payments-backend/pull/6) test module in X backend to listen user transactions. We need activated Paid Apps in Simple Rules account because it's impossible to track in-app transactions with XCode build (missing real transactionId).

2023-11-02 Thu: [Added](https://github.com/harmony-one/x/pull/115) in-app purchase to VoiceAI bot (hold "skip" button for 2 second to purchase 500 "credits"). Works only for local build for now. Investigated how to enable in-app purchases on TestFlight, we need to move VoiceAI to Simple Rules and activate Paid Apps (currently [in pending](https://appstoreconnect.apple.com/agreements/#/) status).

2023-11-01 Wed: [implemented](https://github.com/harmony-one/x/pull/100) in-apps purchase demo with products and subscriptions, using native iOS StoreKit. After publishing in TestFlight I noticed that products list is empty and asked Nagesh to help me with that. It will require some time to setup a new application in a different org with enabled paid apps so in-app purchases will work in TestFlight (not only locally).

2023-10-31 Tue: [Completed](https://github.com/harmony-one/stripe-payments-backend/pull/5) basic methods for X payments service: it support creating new users, refund and widthdraw funds. [Deployed](https://x-payments-api.fly.dev/api#/users) service to fly.io, asked Aaron to review it and discuss the next steps. Continue research Apple [Storekit](https://developer.apple.com/storekit/) to implement payments in iOS app.

2023-10-30 Mon: [implemented](https://github.com/harmony-one/x/commit/f748d5ea3e8779de8fb07d7b187b6126404f0d4a) simple unit test for Payment module in Hey Artem, checking how to implement UI tests. Continue working on payments service DB schema, need to discuss details with Aaron.

---

2023-10-27 Fri: Worked on X iOS app and Payments service. [Added](https://github.com/harmony-one/x/pull/78/commits/9d5dd1a41eef45db3f394d01529a809e1b8574f9) Stripe payments widget to iOS app in ios-artem folder, made the first test payment with credit card using payment service, launched locally. [Implemented](https://github.com/harmony-one/stripe-payments-backend/pull/5/commits/0a4a0b8025f1fdc5daa8248f5a0efeaba77bcb2a) Stripe payment request endpoint in payments service. Started working on handling successful and failed payments from iOS app on the payments service side.

2023-10-26 Thu: Reviewed Aaron's [PR](https://github.com/harmony-one/x/pull/63) with PlayHT support, added it to Hey Artem app. Started reviewing [PR](https://github.com/harmony-one/x/pull/61) with iOS stream. X app payments: [implemented](https://github.com/ArtemKolodko/stripe-payments-backend/pull/6) user balance on payments backend side, added initial credits, implemented Stripe payment intent for X app. Researching Stripe docs with iOS integration.

2023-10-25 Wed: Started working on payments for X app: refactoring DB schema in [stripe-payments-backend](https://github.com/harmony-one/stripe-payments-backend) to support free credits, adding new Stripe payment intent event handler to support Apple Pay.

2023-10-24 Tue: Completed local environment setup for ios-anne. Had s call with Sergey to split the tasks and discuss common pitfalls while working on ios projects. Started setting up com.country.x.artem as a separate project (work in progress).

2023-10-23 Mon: [Implemented](https://github.com/harmony-one/x/pull/55) Google Text-to-Speech using Google API, without a proxy server (this can be used in iOS app). Synced with devs regarding new iOS tasks. Started iOS environment setup. 

2023-10-20 Fri: [Added](https://github.com/harmony-one/x/pull/45) url params for speech and text models, fixed sound interruption: the complete sentence will now be sent to google text-to-speech API. Explored latency issue, it's caused by proxy service and google API latency. Checking for a solution to use Google text-to-speech directly from client app. As another option we can switch to PlayHT.

2023-10-19 Thu: [Added](https://github.com/harmony-one/x/pull/42) TTS drop-down menu to webapp demo with two options: Google / Elevenlabs. Refactored audio tts plugin. Started working on reducing latency (WIP).

2023-10-18 Wed: [Fixed](https://github.com/harmony-one/x/commit/21ebe56a8f813957c2906deb23fbb4faec248682) GPT4 message queue bug; implemented GPT4 stream interruption on a new message from user. Deployed update on https://artem.x.country/.

2023-10-17 Tue: Fixed [issue](https://www.notion.so/harmonyone/No-Audio-Emit-on-Artem-x-country-f9d2ac489e004dc4b9d37b698f5b759f?pvs=4) with audio emitting. Deployed webapp demo on netlify: https://harmony-x.netlify.app, Theo linked it to artem.x.country; deleted fly.io deploy.

2023-10-16 Mon: Added STT model selector to test different models: Deepgram Nova 2 and Deepgram ConversationalAI. [Added](https://github.com/harmony-one/x/pull/25) previous messages to GPT4 request to keep the conversation context.

---

2023-10-13 Fri: [Added](https://github.com/harmony-one/x/commit/d91d171430ffa976d71677b27da95cf1a6d7719e) full Deepgram Nova 2 support in speech-to-text module; [improved](https://github.com/harmony-one/x/commit/dccc64b51dbefd5fef8072bf40839387f2ad575d) interaction with GPT4: speech-to-text module collects chunks of a text and sends them to gpt4 after a delay of 1.5 seconds.

2023-10-12 Thu: Deepgram Nova 2: researched official [docs](https://developers.deepgram.com/docs/getting-started-with-live-streaming-audio), tested Nova 2 with stream support with a test script. Created simple relayer service to keep secrets on backend, [working](https://github.com/harmony-one/x/pull/13) on the X webapp integration with Nova 2 API.

2023-10-11 Wed: [Implemented](https://github.com/harmony-one/x/pull/9/files) sending an STT result to GPT4 by user command. Improved STT chunks parsing and overall UX.

2023-10-10 Tue: Picovoice STT doesn't work very well with text recognition. Checked other models: Speechmatics, Google, RevAI, [added](https://github.com/harmony-one/x/pull/3) Speechmatics streaming STT and started testing.

2023-10-09 Mon: [Worked](https://github.com/harmony-one/x/commit/a4fd48bbb15be869618a14c02d6f909f3c89d314) on improving X app UI. [Added](https://github.com/harmony-one/x/commit/8977ce4739d34df8fecf1a8d956654786a7023c5) start-stop STT.

