2024-03-07 Thu: Continue researching [libs](https://github.com/Sovereign-Labs/sovereign-sdk), and [docs](https://docs.celestia.org/developers/rollup-overview) to deploy a rollup using Celestia's SDK on Harmony Shard 1 (for AI, social, game data). 

2024-03-06 Wed: Study of architecture [sovereign rollup](https://celestia.org/learn/sovereign-rollups/an-introduction/) to use it for Harmony Shard 1 (for AI, social, game data).  Researching Zero Gravity [0g.ai](https://0g.ai/) integration.

2024-03-05 Tue: Deployed BOB (Build on Bitcoin) relayer [contracts](https://github.com/bob-collective/bob/tree/master/src/relay) on Harmony testnet and tried to launch BOB relayer service with testnet rpc.

2024-03-04 Mon: Exploring the possibility of launching the BOB (Build on Bitcoin) [ecosystem](https://github.com/bob-collective/bob) on the Harmony side. Reviewing relayer [contracts](https://github.com/bob-collective/bob/tree/master/src/relay).

___

2024-03-02 Fri: Started researching [bitcoin renaissance](https://bitcoin-renaissance.com/) and BOB (Build on Bitcoin) ecosystems. Inspect BOB bitcoin light client [docs](https://docs.gobob.xyz/docs/build/bob-sdk/relay).

2024-03-01 Thu: Worked on the following tasks on h.country: [Added](https://github.com/harmony-one/h.country/pull/103) support for multiple joint filters: address, tag and location. If filter selected and selecting “all” should show all actions with that filter, selecting the user should then toggle to all actions of that filter and that user (nothing if there are no actions) 

2024-02-28 Wed: Worked on the following tasks on h.country: [Fixed](https://github.com/harmony-one/h.country/pull/100) lazy loading issue. Some UI fixes and source code refactorings.

2024-02-27 Tue: Worked on the following tasks on h.country: [Fixed](https://github.com/harmony-one/h.country/pull/97) google maps links format - now the link also includes country, city and postcode. Removed from the list actions that include check-in without an address, also removed false positives for changing location. Minor style edits.

2024-02-26 Mon: Worked on the following tasks on h.country ([PR](https://github.com/harmony-one/h.country/pull/92)): Connected firestore local cache in multiple tab mode. Connected infinity scroll for the actions table with lazy loading of 100 elements. Optimizations speed up page loading from 8 sec to 1 sec.

___

2024-02-25 Sun: Worked on the following tasks on h.country: looked at possible options for optimizing queries in firebase db to speed up application load. Considered cache options (access data offline). [Reviewed](https://github.com/harmony-one/h.country/pull/90/files) user reactions feature. 

2024-02-24 Sat: Worked on the following tasks on h.country [PR](https://github.com/harmony-one/h.country/pull/84): Added ability to set custom location on click to top right location button. Display check-in action in feeds table. Automatically update the current location if the new location is different.

2024-02-23 Fri: Worked on the following tasks on h.country: [Added](https://github.com/harmony-one/h.country/pull/77) location pin button with new logic - opening google maps with preset location on clik. Removed m/ from slash section. [Added](https://github.com/harmony-one/h.country/pull/80) new logic: Click on a location, get taken to that filter page. Next to the location name, there is a pin symbol. Click on that to open the google maps link to that street.

2024-02-22 Thu: Worked on the following tasks on h.country: [Updated](https://github.com/harmony-one/h.country/pull/56/files) display of user links (custom links and social links) in the links area and feeds table. [Added](https://github.com/harmony-one/h.country/pull/58) new logic: every time user refresh page, open a new tab, etc. -  trigger new action of type "check_in" and update the location at the top of the page. [Moved](https://github.com/harmony-one/h.country/pull/63) all fetch hooks to separate files. [Added](https://github.com/harmony-one/h.country/pull/64) top locations display.

2024-02-21 Wed: [Added](https://github.com/harmony-one/h.country/pull/40) filter by location: includes all actions that were performed by users on this street, as well as marks of some users by others. Refactored filters mechanism api.

2024-02-20 Tue: [Added](https://github.com/harmony-one/h.country/pull/27) latest user location display to header (top left). Updated latest location search mechanism. [Added](https://github.com/harmony-one/h.country/pull/32) logic to marked user (page owner) location when you click on a location (top left header); [Added](https://github.com/harmony-one/h.country/pull/34) display for "locates" actions in the actions list (0/f445 (location) 0/EC68); [Created](https://github.com/harmony-one/h.country/pull/33) Actions Context - to reload actions list from any components.

2024-02-19 Mon: [Added](https://github.com/harmony-one/h.country/pull/20) Street name display, added display links actions, fixed links adding issue. [Corrected](https://github.com/harmony-one/h.country/pull/21) street display format, show all actions for new users (first time visit). [Added](https://github.com/harmony-one/h.country/pull/23) displaying latest location address in links section.

___

2024-02-16 Fri: [Added](https://github.com/harmony-one/h.country/pull/4) shortcuts for user page to load page by id, address or social links. Added shortcuts for tag page. Started tag page migration. [Improved](https://github.com/harmony-one/h.country/pull/7) adding links mechanism and url's parsing. Fixed bugs.

2024-02-15 Thu: Tested and reviewed new auth0 [features](https://github.com/harmony-one/human-protocol/pull/21). Synchronized with Theo about migration to a new [project](https://github.com/harmony-one/h.country). Started transferring the logic for creating actions and selecting tags. 

2024-02-14 Wed: [Reviwed](https://github.com/harmony-one/human-protocol/pull/13) auth0 interactioin PR. [Integrated](https://github.com/harmony-one/human-protocol/pull/16) auth0 provider to main page header. Added user's nickname (from auth0) display to main page. New messages are created with a link to the wallet address. Storing auth0 metadata in firebase (by wallet address key).

2024-02-13 Tue: [Migrated](https://github.com/harmony-one/human-protocol/pull/12/commits/15f65efc2ab3d180021f0f86f568c21a3db8e6e3) more updates from remote-emitter. Fixed bugs. Started working on auth0 integration and storing oauth metadata in firebase.

2024-02-12 Mon: [Merged](https://github.com/harmony-one/human-protocol/pull/12) Julia's remote-emitter to human-protocol client, migrated to typescript, refactoring.

___

2024-01-09 Fri: Configured telegram [lottery](https://q.country). Updated lottery statistic. Worked on schema and flow for "message", "mention", and "interest" for human-protocol client and firebase store.

2024-01-08 Thu: [Added](https://github.com/harmony-one/human-protocol/pull/5) firebase based api, for all current cases: adding user with topics, adding actions, auto increment topics counter. Configured firestore. Integrated with frontend part.

2024-01-07 Wed: [Added](https://github.com/harmony-one/human-protocol/pull/1) api based on cloudflare KV service worker. Api support: adding user with topics, adding actions, auto increment topics counter. Integrated with frontend, testing, bug fixing. Added readme with api description. 

2024-02-06 Tue: [Added](https://github.com/harmony-one/human-protocol/commit/c915544727f13678c4927f0929877b21ce66fdfc) Cloudflare KV worker. Configured and [deployed](https://kv-dev-message.humanprotocol.workers.dev/messages) to harmony account. Currently, the service worker supports adding messages (in any format), receiving messages by key, and a list of keys and messages.

2024-02-05 Mon: Synced with Sun and Jenya. Researched ElastiCache: get/set data (location, media etc), and metrics. Researched ETH Denver [project](https://www.x.country/human-protocol-social-shard-1-00e81d36535a4f2981a18012854b2c1e). Started working on service worker.

___

2024-01-02 Fri: Updated lottery statistic [api](https://inscription-indexer.fly.dev/api#/app/AppController_getLotteryStats): added statistic by telegram username. Worked on indexer api optimisations, to add universal support for all inscription types.

2024-01-01 Thu: Updated [frontend](https://github.com/harmony-one/inscription.demo/pull/10) and [backend](https://github.com/harmony-one/inscription.indexer/pull/11) parts for telegram lottery. Extended lottery service: The algorithm for determining the winner has been changed (added 6 winners support). Updated filters by which lottery transactions are indexed.

*2024-01-31 Wed: Сomplete telegram bot image lottery feature. Added telegram inscriptions support to indexer. Extended indexer [api](https://inscription-indexer.fly.dev/api#/app/AppController_getMetaByDomain) to load and return telegram images by imageId from inscription.

*2024-01-30 Tue: [Added](https://github.com/harmony-one/inscription.indexer/pull/10) support for subdomain and redirect paths from indexer so that they can be used by the client side (endpoint for .country, to get content from inscriptions). Expand the database table and add search for new fields, optimisations.

*2024-01-29 Mon: Сompleted set up for lottery 2.0. [Updated](https://github.com/harmony-one/inscription.demo/pull/9) frontend part. Reviewed backend PR's. 

___

2024-01-26 Fri: [Added](https://github.com/harmony-one/inscription.indexer/pull/7) filter for inscriptions, domains monitoring service and provide an endpoint which .country frontend can query to host content. Validation by url, parsing by types. Updated inscriptions indexer instance.

2024-01-25 Thu: [Added](https://github.com/harmony-one/inscription.indexer/pull/6) stats api to get statistic by lottery inscriptions, unique wallets, txs by wallet. Extended logic for calculation winner: diff by 3 symbol if find several winners. [Updated](https://github.com/harmony-one/inscription.demo/commits/main) frontend part.

2024-01-24 Wed: Inscription lottery launch support. [Added](https://github.com/harmony-one/inscription.indexer/pull/4) api to get tweet link by 2 letter domains, correct lottery time interval, fixed bugs. Did several ui [fixes](https://github.com/harmony-one/inscription.demo/pull/7). Deployed main page to [production](https://q.country/) url.

2024-01-23 Tue: [Finished](https://github.com/harmony-one/inscription.demo/pull/3) the demo version for the [lottery main page](https://hmy-inscription.web.app/) (transaction sending, indexer, winner display). [Added](https://github.com/harmony-one/inscription.indexer/pull/2/files) logic to the backend for monitoring and determining the winner, tweet link validations.

2024-01-22 Mon: Dive in the logic of operation of the inscription lottery. Started working on the [main page](https://hmy-inscription.web.app/) for lottery.

___

2024-01-19 Fri: [Worked](https://github.com/harmony-one/inscription.demo/pull/2) on inscription for .country commands. Auctions through gas fee (we get information about the latest domain inscriptions from the indexer and then use it as a minimum gas for the next domain inscription). Still in progress.

2024-01-18 Thu: Reviewed XRCFactory contract from [gwx.one](https://gwx.one). Reviewed Artem's [updates](https://github.com/harmony-one/inscription.indexer/pull/1) for [Indexer](https://inscription-indexer.fly.dev/api). Starting frontend integration with new api.

2024-01-17 Wed: Demo and transfer of the [Indexer](https://github.com/harmony-one/inscription.indexer) codebase to Artem for further development of .country inscriptions. Started XRCFactory contract review. 

2024-01-16 Tue: Worked on resolving a bridge issue related to upgrading the default proof type to 2 (from mpt to FP). Continue research and migration of the ethscriptions-indexer into Harmony.

2024-01-15 Mon: Researched [facet-vm](https://github.com/0xFacet/facet-vm) and [ethscriptions-indexer](https://github.com/0xFacet/ethscriptions-indexer) repos to explore the possibility of migrating ready-made ethscriptions solutions to Harmony.

---

2024-01-12 Fri: Deployed indexer and hrc20 inscriptions [demo](https://hmy-inscription.web.app/). Researched [github.com/okx](https://github.com/okx) to added harmony chain support.

2024-01-11 Thu: [Worked](https://github.com/harmony-one/inscription.demo/pull/1) on frontend demo for OneScription and inscription indexer.

2024-01-10 Wed: Worked on moe project iprovements and migration to to nestjs engine. Inspecting reason and statistics of bridge errors.

2024-01-09 Tue: Looked into inscription implementation and indexer design

2024-01-08 Mon: Fixed stable diffusion backend server issues (inspected server settings for automatic disk cleanup), reviewed moe repository code

---

2024-12-25 Mon - 2024-01-05 Fri: Paid time off.

---

2023-12-22 Fri: Added indexer [demo](https://inscription-indexer.fly.dev/api) for inscriptions. [Repository](https://github.com/harmony-one/inscription.indexer)

2023-12-21 Thu: Helped Frank solve the problem of building a bridge on a local machine. Started working on indexer for inscriptions.

2023-12-20 Wed: [Added](https://github.com/harmony-one/inscription.demo) frontend [demo](https://hmy-inscription.web.app) for sending transactions with inscription via Metamask.

2023-12-19 Tue: Investigated the problem with purchasing domains on 1.country. Research into inscription tokens.

2023-12-18 Mon: [Added](https://github.com/harmony-one/x/pull/399) twitter lists manage feature, which allowed to configure sources via API endpoints (Any user with API key will be able to add / remove / update twitter list in x-api-backend). Started exploring the possibilities of deploying [evm.ink](https://evm.ink/) to Harmony.

---

2023-12-15 Fri: [Implemented](https://github.com/harmony-one/x/pull/391) "Talk to Me" reading data, loaded from backend. Continue working on "twitter-backend" features.

2023-12-14 Thu: Working with Artem on twitter-api backend. [Added](https://github.com/harmony-one/x/commit/5255a1a70c835ec6454d5bcfac16ca0cb59429b5) table, module and controller to store and manage twitter lists. Next it will be used to load tweets for each list.

2023-12-13 Wed: The tutorial for [deploying Harmony Bridge Tokens](https://delirious-crepe-4c3.notion.site/Add-Bridge-support-for-ERC20-dde13f7f64bf44af9aa93f2dfa2e35ba) and [adding new chains](https://delirious-crepe-4c3.notion.site/Add-Bridge-support-for-new-chain-5748fc212a6d4909b64bf2d26802f2e6) has been completed. [Fixed](https://github.com/harmony-one/layerzero-bridge.appengine/commit/f3cdf2ee6a6460ed7fdfa3ef655ff58917054cc6) an issue with displaying "total locked" tokens. Did a live session with Sun during which we added Linea USDT support to Harmony bridge

2023-12-12 Tue: Added Linea chain and Linea usdc token support to harmony bridge: deployed contracts and update configs ([1](https://github.com/harmony-one/layerzero-bridge.frontend/commit/abedb14b9e73ae9d124ca04e66eda06b8fa4cdb3), [2](https://github.com/harmony-one/layerzero-bridge.frontend/commit/5cf0389d0b0ea8febe943857d8ba3e12a76b6620), [3](https://github.com/harmony-one/layerzero-bridge.appengine/commit/f3e71e016973f273fba57f50afd7b1d81d1474aa), [4](https://github.com/harmony-one/layerzero-bridge.appengine/commit/04ca61f993411644d8e9d69e73dac15bba0bbae6)]). Debugged issues, synced with layer zero team to enable linea<->harmony bridging.

2023-12-11 Mon: [Refactored](https://github.com/harmony-one/layerzero-bridge.frontend/pull/20) layerzero bridge frontend & [backend](https://github.com/harmony-one/layerzero-bridge.appengine/commit/a296a8a9b317d58b9d1d405b1db9273cd457b8c1) to do deployment steps more simple. Preparing a training manual.
 
---

2023-12-8 Fri: [Splited](https://github.com/harmony-one/x/pull/329/commits/e303d086f8a4ec664af950a2060ca59b0eb64574) the benchmarks measurement into 5 steps. The steps are done according to Aaron's [instructions](https://github.com/harmony-one/x/blob/main/doc/benchmarking.md). [Extended](https://github.com/harmony-one/x/pull/329/commits/a26e4d960bc23c61bf67025da75a83c140ec6a6a) relay to support more fields.

2023-12-7 Thu: [Added](https://github.com/harmony-one/x/pull/329) benchmarks for "text to speach" and "speach to text" steps. [Extended](https://github.com/harmony-one/x/pull/329/commits/b7331f0bbea63337b3fd0f5a11fa4efbb94a76fc) relay service to support stt, tts metrics. Continue working on kibana manage to display table with all benchmark stats.

2023-12-6 Wed: Tested [build](https://github.com/harmony-one/x/commit/63fa70f6c4118d7bf5fe66cc2a80f2b9d9c83513) with DeepgaramASR to speed up record start. Working on benchmarks with Kibana.

2023-12-5 Tue: Looking for a solution for microphone handling, specifically to resolve the issue where the first word often cuts off. 

2023-12-4 Mon: [Fixed](https://github.com/harmony-one/x/pull/300) build errors for VoiceAi_2 app. [Added](https://github.com/harmony-one/x/commit/8cfd889d3c760d61aa65843110e9a3f91b68ae9e) more tests for CustomInstructionsHandler. Working on benchmark.

---

2023-12-1 Fri: [Added](https://github.com/harmony-one/x/pull/296) elastic client to collect the stats for elasticsearch and next analyze the request time result in kibana. Working with Segey on resolving "Press and Hold" bug.

2023-11-30 Thu: Inspected different ways to collect benchmarks for open ai requests with different network speed. [Added](https://github.com/harmony-one/x/pull/290) sentry perfomance monitoring example. Working on TimeLogger extension to collect the stats for elasticsearch and next analyze the result in kibana.

2023-11-29 Wed: Working on OpenAI Stream benchmark tests for poor network [tests draft](https://github.com/harmony-one/x/pull/284). Continue working on [AppleSignInManager](https://github.com/harmony-one/x/pull/279) tests.

2023-11-28 Tue: Worked on unit tests for [TimeLogger](https://github.com/harmony-one/x/commit/3ae423546370fef7e8a703709a0a6e73e033e1c7), [AppleSignInManager](https://github.com/harmony-one/x/pull/279) and [SettingsView](https://github.com/harmony-one/x/commit/57423c36bd32ad664c846dacb4c6f7b9823fe9c8) modules. [Added](https://github.com/harmony-one/x/pull/277) refacoring optimisations.

2023-11-27 Mon: [Added](https://github.com/harmony-one/x/pull/269) buttons unit tests: GridButton, PressEffectButtonStyle, Theme. Resolving conflicts nad continue refacoring ActionsView [module](https://github.com/harmony-one/x/pull/259) to decrease cyclomatic complexity.

---

2023-11-24 Fri: [Resolved](https://github.com/harmony-one/x/pull/249) conflicts. [Resolved](https://github.com/harmony-one/x/pull/258) Cancel "Tap to speak" record on press any other button. Fixed eslint errors and build issues. [Refactored](https://github.com/harmony-one/x/pull/259) ActionsView to decrease cyclomatic complexity.

2023-11-23 Thu: [Fixed](https://github.com/harmony-one/x/pull/249) problems when pressing multiple buttons at the same time (now you can't use "Tap to speak" and "Press and hold" at the same time).

2023-11-22 Wed: [Improved](https://github.com/harmony-one/x/pull/245) "Pres & Hold" button handling (fixed lags on spam). [Removed](https://github.com/harmony-one/x/pull/246) long press handling from all buttons; Added "More Action" button. Working on improving buttons handling on "many buttons press case".

2023-11-21 Tue: [Fixed](https://github.com/harmony-one/x/pull/237) "Tap to Speak" issues: changed to "Tap to Speak" instead of "Tap to SPEAK", fixed colors blink on spam, fixed button delay and lags on spam. [Increased](https://github.com/harmony-one/x/pull/239) openAI rate limits. Continue working on tests.

2023-11-20 Mon: [Added](https://github.com/harmony-one/x/pull/231/files) unit tests for: ThemeManager, NetworkManager, AppleSignInManager modules. Updated NetworkManager module to improve test coverage; Added mocks for emulation network response.

---

2023-11-17 Fri: [Configured](https://github.com/harmony-one/x/pull/211) "Voice 2" build for internal testing. Сontinue work on unit tests for stream modules and ui buttons.

2023-11-16 Thu: [Resolved](https://github.com/harmony-one/x/pull/197) bugs regarding long press triggering tap functionality (when pressing long, unnecessary actions were triggered). Investigating the possibility of eliminate mic initialization lag when using "Press & Hold".

2023-11-15 Wed: [Implemented](https://github.com/harmony-one/x/pull/189) button debounce after 10 taps to prevent crashes, also fixed pause/play lag. [Added](https://github.com/harmony-one/x/pull/192) UI tests for new cases. Working on delay correction long press triggers in App purchase.

2023-11-14 Tue: Working on setup more comprehensive/granular sentry logs. Helped Nagesh with setup/test [branch](https://github.com/harmony-one/x/pull/182) (uploads dsym file). [Added](https://github.com/harmony-one/x/pull/183) swiftlint tool to enforce Swift style and conventions. Fixed project sources lint styles.

2023-11-13 Mon: Working on setup buttons [debounce](https://github.com/harmony-one/x/pull/170/files) to have better app stability (prevent crashes etc). Working on setup more comprehensive/granular logs (sentry)

---

2023-11-10 Fri: [Resolved](https://github.com/harmony-one/x/pull/161) issue with long press actions (Ensure long press actions do not trigger tap actions vice versa). Working on tracking active using app time and showing suggestions to share with friends and share on Twitter.

2023-11-9 Thu: [Added](https://github.com/harmony-one/x/pull/148/files) the ability to repeat the current session to resolve repeat bug (When hitting "Repeat" during the first stream, it says "Hey" while the stream is going. It should just start again from the beginning instead.) 

2023-11-8 Wed: Continue working on [error capturing](https://github.com/harmony-one/x/pull/136) based on Aaron's [checklist](https://github.com/harmony-one/x/blob/main/doc/checklist.md). Added action buttons metrics based on sentry ui metrics.

2023-11-7 Tue: [Working](https://github.com/harmony-one/x/pull/136) on logging an iOS application using sentry.io as a platform for storing and viewing logs

2023-11-6 Mon: Working on reolving "speaker popping" issue (reproduced on quickly pause/play switch and new sessioan start). Bridge tasks support (btc tranquil payments).

---

2023-11-3 Fri: Working on build and review unit tests for voice ai. Updated staking dashboard ui. bridge tickets support.

2023-11-2 Thu: Working on different UI fixes: beep signal on released speak button, speak and pause bottons color changing sync, pause button blinks. Continue working on unit tests update. 

2023-11-1 Wed: Working on UI fixes for Press to Speak button (colors, stuck). Unit tests for GPT Streaming module (in progress). Support for staking dashboard with mainnet shard reduction from 4 to 2.

2023-10-31 Tue: [Added](https://github.com/harmony-one/x/pull/94) ChatGPTSwift lib for better gpt streaming stability / resolving bugs. Working on unit tests for Streaming module and UI components.

2023-10-30 Mon: (Resolve bugs in GPT streaming PR, specifically button interaction and async request/response handling) Continue working on GPT streaming [PR](https://github.com/harmony-one/x/pull/84)

---

2023-10-27 Fri: [Added](https://github.com/harmony-one/x/pull/80/files) deepgram streaming to main app. Working on button integration with streaming workflow.

2023-10-26 Thu: Reviewed Aaron's streaming code pr's. [Copied](https://github.com/harmony-one/x/pull/72) streaming core sources to ios-yuriy for next whishper integration. Continue working on bugs from kanban board.

2023-10-25 Wed: Working on bug fixes for Voice AI app: the "Speak" button becomes non-functional while ChatGPT is processing, and the "Pause" button loses its functionality while the response is being processed.    

2023-10-24 Tue: Continue working on full IOS end-to-end demo using Whipser, GPT4, and Elevenlabs: setup build and starting integrate Whipser speach to text via rest api.

2023-10-23 Mon: Started working on full IOS end-to-end demo "Emotion Build" (using Whipser, GPT4, and Elevenlabs). Reviewed Hey Julia project sources. [Added](https://github.com/harmony-one/x/tree/ios-emotion-build/mobile/samantha) project structure.
 
---

2023-10-20 Fri: Added more text to speech integrations to willow demo: [Google Cloud](https://github.com/harmony-one/x/pull/44), [Microsoft Azure](https://github.com/harmony-one/x/pull/50). [Added](https://github.com/harmony-one/x/pull/48) select dropdown for speach to text to willow demo. Started setting up play.ht

2023-10-19 Thu: [Added](https://github.com/harmony-one/x/pull/44) STT Deepgram streaming widget for wis demo. Working on table to see historical latency data to compare.

2023-10-18 Wed: 
Started work on Emotion build. [Added](https://github.com/harmony-one/x/pull/39) TTS Core select (Elevenlabs + Willow microsoft model) for WIS end to end [demo](https://yuriy.x.country/). [Added](https://github.com/harmony-one/x/pull/41) more metrics (stt + llm + tts).

2023-10-17 Tue: 
Completed WIS end to end [demo](https://yuriy.x.country/) Working on streaming for WIS STT.

2023-10-16 Mon: 
[Working](https://github.com/harmony-one/x/pull/27) on full end-to-end gui for Willow based on Willow [rest api](https://54.186.221.210:19000/api/docs#/)

---

2023-10-13 Fri:
[Willow demo draft](https://github.com/harmony-one/x/pull/17) Added willow demo draft. webrtc stt working, continue working on other functions (tts, sts, speaker change). [Resemble AI demo](https://github.com/harmony-one/x/pull/19)

2023-10-12 Thu:
[Added](https://github.com/harmony-one/x/pull/10) the gdansk-ai repository, worked on deployment and setting up the environment. Started diving into api/docs for Willow inference server - for the next creation of a webapp demo.

2023-10-11 Wed: [1 part](https://github.com/harmony-one/x/pull/7) [2 part](https://github.com/harmony-one/x/pull/8) - Added storing/displaying of gpt chat history + updated UI; [Refactoring](https://github.com/harmony-one/x/pull/6) - Added Mobx state manager, update layout; Working on store/display metrics for (stt-gpt-tts) (eta - today)

2023-10-10 Tue: [Completed](https://github.com/harmony-one/x/pull/4) - Added tts audio player, integrated with elevenlabs (rest) and gpt streams, integrated with Artem's PR's. Code refactoring. Started work on UI improvements.

2023-10-09 Mon: I tried different options for working with TTS Elevenlabs (rest, ws), tried different sentence breakdowns. At the moment, we managed to achieve requests of 1.3 seconds for each sentences from the chatgpt stream. Also the current tts engine has many problems and often audio tracks overlap each other - a player is needed to manage them. Then i started working on the adding the tts audio player to project (smart management of audio chunks), and its integration with the chatgpt and elevenlabs stream [Worked](https://github.com/harmony-one/x/pull/4)
