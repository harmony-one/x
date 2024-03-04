2024-3-1 Fri (10h): Implement new map based frames with review and check-in. Implement counters for mint and 24-hour mint. Add mock-mint mode. Deploy and demo in production. Implement styled dynamic text at line-level for SVG. Improve location parsing and display. Allow optional location suffix, and natural syntax for users to override on location suffix. Debug and submit single-letter domain issues on Warpcast. Test redirect, proxy, CNAME, URL transform and various ways to circumvent the single-letter naked domain bug. Improve text and button display for map extension. Separate basic-map and map extensions. Implement permanent key-value storage for review and check-in. Deploy, configure and test redis for embedded web service. Implement safe mint, count, and balance query, and dynamic image for with cache control. Implement static statistical image API. Inscribe review and check-in location on-chain during mint. Deploy to production and test end-to-end

2024-2-29 Thu (8h): (Continued) Breakdown and refactor Farcast implementations by extensions. Fix multiple implementations bugs and structural issues. Discussions, technical Q&A, and task planning on Farcaster frame implementations. Research on WARP tokens. Cloud configuration and deployment. Implement Redis client. Research on Redis data structures to use for temporal count and aggregation. Deploy, configure and test redis for embedded web service.  Debug dot-country purchase issues. Reconfiguration of lend.country documentation sites and discussion on SSL wildcard certificate renewal and auto-deployment issues

2024-2-28 Wed (3.5h): Review and test fixes for Substack error message. Burner rate and mechanisms update, redeployment. Review and comment on DCReward on-chain minting implementation. Research on Promise pool, implement queued asynchronous minting with fast frame resposne. Review and finalize fixes for Substack error message issues. Review and revise on-chain minting code, metadata, and configurations based on DCReward.

2024-2-26 Mon (0.5h): Analysis and debug of AWS to embedded web service redirect issues and unicode / ASCII encoding issues. Review embedded web service preview generation and special routes 

2024-2-24 Sat (2.5h): Farcaster integration debugging and discussions. Warpcast client - frame server interaction flow analysis. Access-controlled dot-country reward minting contract with metadata URI management. Dependencies and compiler upgrades. Bug fixes of Farcaster frame preview

2024-2-23 Thu (11.5h): Implementation and testing of dynamic rendered text in SVG with styling options. Alternative Farcaster frame use case exploration. Research on Google mapping embedding and SVG-based solutions. Research, experiment, and integration of static Google map image and styling, and interactions with Farcaster frame and its requirement. Bug fixes and Farcaster POST message validation analysis. Dynamic static, styled map image for Farcaster frame, callback route and error handling, end-to-end debugging, testing, deployment, demo, and production trial. Dynamic-image generation for Farcaster text frame, Farcaster text inscription initial frame, POST callback route and error handling, with debugging, and testing. End-to-end deploy, debugging, demo, and production trial for text-inscription Farcaster frames. Discussion of TODO on token minting in production.

2024-2-22 Thu (10.5h): Evaluate Substack page DOM structures, various DOM parsers, and experiment on adding Farcaster frame data through DOM manipulation. Finalizing Notion embedded page and Farcaster frame integration. Add customizable token name, initial Substack support, and fix issues in configuration. Farcaster frame and Substack integration. Resolve compatibility issues, add configuration syntax . Test through management UI. Initial implementation of Farcaster callback route. Add and implement unified parse settings for Substack and Notion, add Farcaster flags and extension syntax. Resolve Farcaster certificate validation issues for tunneled development host. Add HTTP support, configurable protocol, host extraction, default image in absense of OpenGraph image from Substack or Notion page. Fix missing frame properties, bugs, add redirect routes. Fix Farcaster frame-mint failure cases, redirect handling. Fix Farcaster message validation, add id extraction, lookup and owner address mapping. Fix hub client integration. End-to-end deploy, debugging, demo, and production trial of Notion and Substack default Farcaster integration. Demo and experiments on error handling and text-input submission and validation. End-to-end deploy, debugging, demo, and production trial of Notion and Substack default Farcaster integration. Demo and experiments on error handling and text-input submission and validation

2024-2-21 Wed (5.5h): Farcaster specification review, API and hub experimentation. Review and evaluate sample frame implementations and production apps. Initial implementations in dot-country embedder for integration. Design and implement Farcaster partial template and configurations. Integrate with existing opengraph renderer server implementation, and settings from embedded-web-services contracts

2024-2-20 Tue (4h): Review Farcaster FIPs, documentation for client development, core concepts, account, messages, and names. Evaluate Farcaster developer toolkit, community-developed packages, and simple demo frames related to mint and polling. Evaluate compatibility issues of server-side rendering and use of next.js. Evaluate Farcaster APIs, frame specifications, data schemes

2024-2-19 Mon (3.5h): Review Human Protocol new developments, plans, and issues. Review Farcaster design, architecture, developer documentations, APIs, and frame integrations. 

2024-2-12 Mon (0.5h): Evaluate and discuss Human Protocol demo apps, suggest features and engineering improvements

2024-2-11 Sun (0.5h): Compute, review, and discuss recovery analytics and implications of increased market rate for depegged assets. Update and aggregate results from multiple contracts belonging to a large round.

2024-2-09 Fri (4.5h): Configure, deploy and end-to-end testing for VPN with network congestion simulation. Create one-click VPN installation profiles for macOS and iOS. Manual Cisco VPN setup instructions. Fix DNS, certificate, and subdomain embedding issues with lend.country and docs.lend.country (reassigning nameserver, re-generate certificates, fix infinite redirect loop by Cloudflare, fix missing ownership on blockchain by manual registrations, manual configuration of DNS and notion embeddings, bifurcate subdomains and reassign nameserver to Cloudflare). h.country DNS and nameserver migration. Documentation for VPN server with traffic control. 

2024-2-08 Thu (6h): Review progress and discussion on Lottery and Human Protocol implementation. Research on Telegram group-wallet design based on Human Protocol / Minimal Social Wallet. Debugging and fixing L2TP IPSec VPN server and ppp issues caused by non-standard GCP cloud linux kernels. Research and experiment on options and tools for network emulation in GCP (Cloud Armor), docker (pumba), and vanilla Linux tools (netem).

2024-2-07 Wed (5h): Resaerch and discuss Godaddy and ENS integration and examples. Review ENS DNSSEC implementation and OffchainDNSResolver. Discuss general ways to support new preview crawler. Review Cloudflare Page hosting and discussions on DNS requirement and nameserver migration and limitation. Initial review of Cloudflare API. Review Cloudflare worker and KV store documentations. Discuss choice of key-value database for fastest response. Review Cloudflare API documentation on batch domain activation. Review Cloudflare token architecture and access control, and configure limited scope tokens accordingly. Review OffchainDNSResolver contract and ENS-GoDaddy gasless domain registration architecture. Discuss downsides anad flaws. Migration of special 2-letter domains to Cloudflare. Fix social preview issues of embedded web services for farcaster, analyzed and expanded user agent matching list. Initial IPSec / IKEv2 VPN deployment, Debian isntance setup, Docker configuration. Initial testing of VPN server via Debian host machine instead of container CoreOS.

2024-2-02 Fri (1h): Research on plans and features in human protocol

2024-2-01 Thu (2h): Domain renewal documentation and script usage. Refine domain renewal document. Review discussions and progress on new projects on lottery, Telegram bot, inscription, and dot-country changes

2024-1-31 Wed (1h): Review inscription backend services and change requested for embedded web services in catering 2-letter domains. Discuss minimal implementation and fork. Quick review and discussion on client side changes of dot-country

2024-1-29 Sun (5h): Domain web2 renewal API, registrar domain info and expiring domain list API integration. Script for batch domain renewal, review existing user and test domains, end-to-end debugging and testing. Discuss erroneous Namecheap renewal API response and incorrect account and pricing setup with registry. Implement lookup-only mode for renewal script. Manual domain renewals and management. Discussion on enable-subdomain errors and ens-registrar-relay routes, and existing main implementations (Notion, Substack) for embeeded web service.

2024-1-28 Sun (4h): Docs for batch certificate renewal, management, access control, and modification guide. Refactor scripts for multi-purpose. Setup certificate management instances and access. Docs for manual certificate renewal for external domain. Renew certificates for key domains

2024-1-25 Thu (0.5h): Discussion and documentation on certificate generation, renewal, management, and processes

2024-1-23 Tue (2h): Review minimal social wallet POC and history. Review paper trading bot. Review partial evaluation implementations in blockchain and smart contracts, and analyze options.

2024-1-22 Mon (2h): Legal research and analysis on Clark v. CFTC appellate opinion, injunction, history and applicability of CFTC no-action letters and enforcement practice. Legal analysis on prediction market risks and issues on developing, deploying, operating a platform, and importance of decentralization. 

2024-1-21 Sun (8h): Implement and deploy system services for email alias services. Auto renew certificate on regular schedule. End-to-end testing printer use cases, with SMTP and email alias forwarding. Research on prediction markets. Research on the history and various legal opinions regarding Polymarket and its terms of service. In-depth analysis of CFTC v. Polymarket. Research and analysis on Thales prediction market design, contracts, AMM, UMA oracle, and demo prediction market contract. Evaluate alternatives.

2024-1-20 Sat (6.5h): Refine and finalize batch multi-certificate renewal scripts. Verify reserved and blocked domains. Quick review of ICANN rule. Debug and test premium domains. Sync all domain-related repositories. Review prediction market products, legal research on applicable laws and enforcement actions. Experiment with SMTP services for email alias services. Upgrade email alias services to latest common stack (ether v6, node 20). Debug various type and compile issues arising from hardhat, typechain, and typescript. Debug and implement workaround for missing Harmony protocol RPC implementation on eth_gasEstimate

2024-1-19 Fri (6h): Review and analysis on inscription contract code: mint, buy, sell, withdraw, supply and balance control, and other internal logic. Review new Telegram embedded wallet proposal, analyze prior art, evaluate options to extend SMS Wallet and other design options. Debug and fix issues related to unable to manage domains using dot-country domain manager. Premium and reserved domain management. Implement batch multi-certificate renewal script

2024-1-18 Thu (5.5h): Deploy certificate auto-renew automations on key dot-country and ai-bot services. Debug dot-country Substack embedder URL link hostname issues, analyze new scripts and page load mechanism from Substack. Experiment with a variety of DOM and Javascript listeners. Deploy temporary fix. Quick review of inscription contract code on security, integrity, and deployment issues. Review latest Multisig configuration and code change log. Discussion on technical and legal issues pertaining to raffle / lottery, prediction market, and similar mechanisms through NFT airdrops

2024-1-17 Wed (4h): Analysis and in-depth review on amicus brief by DeFi Education Fund in SEC v. Coinbase, review hearing transcript and updates of the case, discuss legal authority on asset ownership in custodial service, distinguishing factors of ministerial v. managerial service providers, and how they apply to bridge and swap services

2024-1-16 Tue (5.5h): Debug and discuss Multisig iOS RPC call issues. Review code and UI update progress. In-depth legal research and analysis on Underwood v. Coinbase, effect and importance of user agreement, asset title transfer, asset custody, control, transaction and order fulfilment mechanism, fees, and choice of assets on the platform. Review related cases such as Anderson v. Binance.

2024-1-15 Mon (4.5h): Legal research on Uniswap terms of service, legal structures, and litigations. In-depth legal research and analysis on federal district court opinion and case files on Risley et al. v. Uniswap, cited case laws, statutes, alleged facts, and applicaibility to bridge / swap products

---

2024-1-14 Sun (5.5h): Analyze reusable components in SMS Wallet mini-wallet for minimal social wallet and modifications required for inscription use cases. Research and analysis on lottery, contest, sweepstake statute and case laws, and applications in on-chain transactions and inscriptions. Research on calldata limitations and block size historical changes. Quick review and discussions on Safe iOS code and configurations.

2024-1-13 Sat (2h): Research on inscription technical development history, use cases, adoption, and minimal social wallet integration and design. Research and discussion on recovery supply issues and bugs in explorer backend for computing supplies

2024-1-12 Fri (2h): Implementing CNAME record setup for root subdomain in dot-country domains, testing and deployment end-to-end. Domain renewal and management. Review and research on inscription data carrying and retrieval capacity.

2024-1-11 Thu (2.5h): Review #393 (comment over defining test behavior using class variable instead), #394, #395, #396, #397, #398, #399 (concern over access control), #400, #401, #402, #403, #404, #405, #406 (comment on sampling rate), #407, #410, #411, #412, #414, #415 (note on TTS response streaming, and model name confusions), #392 (draft). Burner launch and resolving cache issues.

2024-1-10 Wed (4.5h): Review #318, #319 (concern on confusion over exporting transcript / log), #320, #321 (concern over dropping support for other languages), #322, #323, #324, #325, #327, #328, #330, #331, #332 (comment on private key could derive address), #333, #334, #335, #336, #337, #338, #339, #340, #341, #343, #344, #348, #353, #354, #355, #361, #363, #368, #369, #370 (comment on JSON parsing complexity), #371 (comment on function signature modification solely for testing), #372, #373, #379, #381, #383, #385, #386, #380 (concern on conflicts and PR being left open), #387, #388, #389, #390, #391

2024-1-9 Tue (2h): Recovery live stats, analytics and charts with WONE support. v7 client portal. New contract and revised parameters for large rounds. Technical Q&A. Domain management and renewal reversal

---

2023-12-11 Mon (5h): Draft and publish design and architecture document for personalized response and Twitter integration 

---

2023-12-10 Sun (4h): Research on Twitter API access, authentication, OAuth flow, pricing, rate limit, usage caps, restrictions, and differentiation on app and user access. Experiment on Lists and search, and related APIs

2023-12-09 Sat (4.5h): Refactoring Benchmarking code logic and variables to be consistent with documentation. Add total text-to-speech time, Fix text-to-speech time related comments. Update ElasticSearch mapping definition and Relay request processing, and env examples. Increase relay setting retrieval timeout. Fix missing send log triggers. Add speech-to-text preparation time. Measure app recording time and speech-to-text recording time to TimeLogger. Add model fields to records. Add new Relayer for production server. Check backward compatibility. Update ElasticSearch mapping. Debug and test end-to-end

2023-12-08 Fri (2.5h): Discussion and research on personalized context based on Twitter and other data sources. Review #329 (comment on text-to-speech measuring issues, branches with zero speech-to-text, and future TimeLogger structure). Fix benchmarking guideline typos. Further review #329 (comment on branches of execution where logs are not sent, premature termination of benchmarking, incorrect measurement of speech-to-text text result and benchmarking termination). Research and test built-in SpeechRecognition non-blocking calls, callback checkpoints and finalization flags. Test end-to-end and evaluate correctness

2023-12-07 Thu (4.5h): Benchmarking guideline: measurement timelines, key metrics, metadata, client implementation notes. Investigate wallet theft and unusual fund flows

2023-12-06 Wed (5.5h): Discussion and feedback on benchmarking and measurement. Research on locale and language settings for tests, and issues related to optional chaining and branch conditions in test coverage. Drafting benchmarking guideline: infrastructure details, and measurements

2023-12-05 Tue (3h): Debug MetaMask mobile signing issues on Gnosis and Multisig, replicate signature issues in version 7.12.0. Inspect Gnosis backend service code for potential workarounds, and review MetaMask code changes and version history. Discussion on ways of audio capturing improvements. Review MetaMask mobile reported issues, debug underlying cause, create a workaround and demo. Research on edge models and Apple Silicon ML frameworks. Review #298, #299, #300, #301 (comment on API key's access and safety, and sentry capturing tags), #302, #303, #304, #305, #306, #307, #308, #309, #310, #311 (request for version alert extra content), #313, #314 (comment on silent failure), #315, #316, #317, #312 (open, question on integration with Siri, watch, and apps)

2023-12-04 Mon (1h): Debug and fix tweet embedding issues. Further analysis on pull requests and commits

2023-12-03 Sun (1h): Demonstration and discussions on Kibana client metrics and raw log. Analysis on pull requests and commits.

2023-12-02 Sat (0.5h): Research and discussions on sheet popup sizing and layout control options, limitations prior to iOS 16, alternative libraries and potential impact to build. Review logs and events captured during end-to-end testing of apps

2023-12-01 Fri (3.5h): Review #273, #274, #275, #277, #278, #279 (comment on sign-in test coverage), #280, #282, #285 (comment on nil-able variables), #286, #287, #288, #289 (comment on configurable variable), #283 (draft), #284 (draft, comment on mock benchmark purposes), #290, #291 (comment on language code as setting). Review iPad actionsheet issue. Discuss ElasticSearch charting issues and tasks. Discuss NLP pipeline and processing of other languages. Review #296 (concern on redundant ElasticSearch implementation at client), #292, #294, #293, #295. Research options for multi-action popups for iPad actions and compatibility, experiment, debug, and fix issues 

2023-11-30 Thu (1.5h): Review and debug multisig 422 error and signing issues from some devices. Review #266, #267, #268, #269, #270 (questions on deterministic test issue), #271, #272 (questions on audio tap removal, comment on whether actual functionalities are tested and need for more advanced action simulation).

2023-11-28 Tue (1h): Research and discuss benchmarking options and metrics. Research scalable benchmarking and user testing tools (Mechanical Turk, Sofy, Usertesting, and others).

---

2023-11-25 Sat (6.5h): Review #260, #262. Devops role and user setup for Kibana and ElasticSearch. End-to-end testing and cluster management for voice app client performance and metric analysis. Perform Apple device check on relay using client submitted device token. Retrieve relay mode and OpenAI base URL from server. Fix attestation caching, key regeneration mechanisms and triggers. Add ways on server to expire an attested key. Allow multiple package ids for hard attestation verification. Bug fixes and end-to-end testing, deployment.

2023-11-24 Fri (7.5h): Review #235, #236, #237, #238, #239, #240, #241, #242, #243, #244 (commented on concern over use of trademark terms and proposed alternative), #245 (press and hold delayed processing - commented on concern over missing input word), #246, #247, #248 (tests on OpenAI streaming - commented on possible improvements on using mock server instead of states that are only useful for tests), #249 (multi-button tap - commented on complexity concern), #251, #252 (performance metric measurements - commented with TODO), #253 (UI action tests - requested additional tests with more depth), #254, #256, #257, #258, #250 (open, transcript export - commented on concern over ineffective filtering), #255 (open). Relay API for performance times and metrics. Refactoring relay APIs and utilities. Client side implementation for TimeLogger. Refactoring device token generation. Creating generic time and performance metric logging and measurement utility.

2023-11-20 Mon (2h): Analysis of first response time. Kibana quick setup for Voice AI app. Research on latency improvement plans and alternatives to OpenAI. Review #221, #222, #223, #224, #227, #229, #230, #232, #233, #234.

---

2023-11-19 Sun (1.5h): Research on Azure compute, AI support, and Anthropic. Wallet theft analysis. New Burner mechanisms through WONE, end-to-end testing, production deployment.

2023-11-18 Sat (N/A): Technical research on state-of-the-art and recovery community service.

2023-11-17 Fri (8.5h): Debug issues that prevent some clients from obtaining relay tokens. Add structed errors and codes for relay client. Capture errors. Auto-retry at client side. Do not override token if failed to get one. Allow new session button to get a new relay token. Cache attestation and challenge at client side. Deterministic generation of relay token. Implemented banned list for relay token. Added ElasticSearchintegration and basic request and response measurement. Store attestationHash and ban user based on that, instead of auth token. Make auth token change every 30 minutes. Review #210, #181 conflicts, #217, #214, #213, #212, #211, #209, #208, #207, #206, #205, #204, #203, #202, #198, #197, #194, #193, #192, #190, #189, #187, #185.

2023-11-16 Thu (2.5h): End-to-end debugging and testing for app attestation and relay-based OpenAI queries. Debug and fix issues related to verifying develop-environment attestation. Fix issues related to non-functioning app caused by multiple initialization of relayer authentication module. Review devops TODO list proposal. Review and discuss in-app purchase flows (#196) and integrations with server.

2023-11-15 Wed (6h): Review in-app-purchase issues and existing implementations. Discuss key leakage issues and review logs. Implement RelayAuth client module for app attestation and relay token management. Debug and fix issues with relay app attestation verification and logging. Discussion on key protection. 

2023-11-14 Tue (3.5h): Fixing SSL issues and domain registration issues. Review and implement EWS Substack anchor link sharing. Review implementation plan and issues for account signup, login, in-app purchase restoration. Review #179, #181, #183, #182, #184. GCP IAM setup for devops personnel, and ElasticSearch operation instructions. Debug MetaMask mobile issues on multisig. Recovery security discussions. Research on and discuss OpenAI Assistant and threading APIs.

2023-11-13 Mon (3h): Technical interview and post-interview analysis. Implementing and testing in-app purchase for GPT-4 booster. Review #167, #168, #169, 170, #171, #173, #174, #175.

---

2023-11-12 Sun (0.5h): Review app payment server and API design and discussions.

2023-11-11 Sat (6h): Implement basic key protection in relay with AES encryption, multi-key rotation, device id and ip tracking, ban list, and key retrieval API with rate limit. Implement client side decryption and initialization. Client side bug fixes, end-to-end testing. Deployment on GCP and systemd service with instance metadata as parameter. Setup and build guide. Allow local key override.

2023-11-10 Fri (1.5h): Review #141, #157, #159, #160. Research on GPT chat session, context compression and effects. Interview preparation and discussion on technical problems.

2023-11-09 Thu (5h): Review #144, #145, #146, #148, #149, #150, #151, #152. Implement QPM limit on streaming services, and rate-limit error handling. Test end-to-end. Research and analysis on iOS market shares by versions, and minimally required versions for key features. Code refactor and applying universal formatting. Implement GPT model switch based on GPT usage time. Implement random alert to share and review based on app usage time. Test end-to-end and fix bugs.

2023-11-08 Wed (4h): Review #138, #139. Testing for bugs in complex audio conditions. Update production checklist. Review language requirement, support channel integration, built-in analytics. Review and discussion on checklist suggestions. Technical interview preparation. Extend production checklist with audio bugs, UI bugs, and customer support features. Cleanup and backup Notion data. Fix issues on mail aliases services, implemented pagination. Update checklist on version control issues. Review deep links into settings.

2023-11-07 Tue (2.5h): Make initial production checklist. Research on app analytic systems and integration complexity. End-to-end testing of the app. Fix SSL issue and document steps for future incident resolution. Fix Tweet embedding issues, CSS issues for notion embedding, and research on tweet libraries.

2023-11-06 Mon (2h): Review #114, #115, #117 update, #118, #119, #120, #121, #123, #125. Review OpenAI new offerings and ways of integrations.

---

2023-11-03 Fri (0.5h): Review #117. New domain and DNS configuration. Review Linux ML development portability to iOS.

2023-11-02 Thu (1h): DNS configurations for lend and Cloudflare issue diagnosis. Lend legal term review. Discussions with security vendors on manual review of swap. Review on-device models and compatibility with iOS devices.

2023-11-01 Wed (4.5h): Fix "Repeat" button's queueing issue. Fix "New Session". Fix speak button press and release logics. Experiment with shorter word utterance. Fix EAS rate limiting and maintainer issues on x.country and implement caching. Review recent updates (#108, #105, #104, #101, #99) and resolve merge conflicts. Fix "Pause / Play" button bug where the button is sometimes ineffective.

2023-10-31 Tue (2.5h): Reimplement for press-to-talk mode, end-to-end debugging and testing. Further research and actions on phishing warning resolutions. Review #93, #95, #97. Fix bugs and crashes related interrupting OpenAI queries. Discussions on present user experience issues and bugs. (Continued) and discussions on on-device work TODOs.

2023-10-30 Mon (5.5h): Review code updates and errors related to OpenAI streaming (#82, #83, #88, #87, #86, #84, 81). Fix OpenAI streaming implementation and integrations, graceful error handling, crash issues in classic Speech Recognition crash issues, various button failures and unexpected responses. End-to-end debugging and testing, and publishing new deployment in Hey Sam. Discuss findings and tasks related to key protection and attestation. Live discussions related to OpenAI streaming issues.

---

2023-10-29 Sun (1h): Code review and discussions on alternative OpenAI and Deepgram streaming implementations, recent pull requests and versions, product updates.

2023-10-27 Fri (4.5h): Deploy and setup relay server instance with domain and certificates. Implement certificate chain verification and binary to PEM conversion. Revise and fix bugs on attestation verification. Implement client side examples for using Relay with TODOs.

2023-10-26 Thu (6.5h): Documenting, testing implementation and TODOs. Implementation of Relay and integration with attestation verification. Code review on recent PRs #70, #73. Review attestation formats, WebAuthn libraries, research on DER encoding, Octet string, ASN.1 sequence, and the maximal use of jsrsasign library. Revise attestation verification implementaiton on missing steps (nonce verification, certificate chain). Research on X.509 custom extension field retrieval, jsrsasign library inner working and utility functions, and past issues and solutions

2023-10-25 Wed (5.5h): Research on OpenAI key generation process, security recommendations. Research on Apple app attestation and integrity services, verification algorithm and reference implementations. Research on CBOR and WebAuthn standards and related libraries, and app attestation design and format. Step by step implementation of attestation verification. Verify reference implementation on public key construction.

2023-10-24 Tue (9h): Fix issues with streaming ASR error handling, payload parsing, keep-alive, auto-resuming, and closing. Implementing OpenAI streaming response handling, piping ASR to OpenAI, streamed toke nresponse processing. Piping to Speech synthesizer for end-to-end demo. UI Button integration and implementation based on streamed components. Debugging, end-to-end testing of streaming ASR (Deepgram) + LM (OpenAI). Debugging capturing activation for AVCaptureSession and implementing workarounds. Implement basic measures to counter self-interference (pause listening while speaking), fine-tune parameters and sentence delimiting to compare model performance, deploy to TestFlight. Review PlayHT streaming implementation, documentations, models and styles. Resolve merge conflicts. Implement TTS streaming skeleton. Review latest code commits, package dependency sizes. PlayHT basic partial integration, with TODO instructions. Evalaute and experiment with PlayHT models and parameters.

2023-10-23 Mon (6h): Complete Deepgram integraiton. Research on audio buffer splitting and joining. Implement and debug stream ASR end-to-end. Research, debug, and fix issues related to native websocket continuous receiving errors, reconnects, and sending errors for various payloads (keepalive, data). Simplify JSON payload parsing and encoding. Research and implementations on audio buffer merging, splitting, metadata retrieval and computation, and raw buffer parsing and manipulation. Debug x.country preview issues, app store app internal user access issues. Discussion on development process, concurrent implementation structure, forks, and merges.

2023-10-22 Sun (5h): Deepdive on Deepgram API option and experiemtnation. OpenAI streaming API research and issue review. Building websocket messaging around Deepgram streaming integration and error handling. Research on low level header files for settings related to audio encoding, sample rate, and others for configuring output buffer. Research on audio buffer manipulation and experimentation. Implementation of audio buffer data conversion. Review simjilar issues reported online related to merging and splitting audio buffer. debugging and testing.

---

2023-10-21 Sat (2.5h): Implementing ASR websocket integration, functions for basic commands and controls. Revisiting documentation on Core Audio streaming methods and determine the best implementation approach. Review AudioToolBox and related alternatives and evaluate. Reviewing and implementing AVCaptureSession and AVCaptureAudioDataOutput

2023-10-20 Fri (3h): Review Hey Julia code. Fix configuration issues, build, deploy on TestFlight and discuss minimal steps for continued development. Forking iOS development versions, reconfigure projects in each folder, and deploy Hey Eve

2023-10-19 Thu (0.5h): Manage new app bundle ids, Test Flight configurations, corresponding provisioning profiles, and internal tester groups.

2023-10-18 Wed (4.5h): Research on iOS audio, speech, networking (native websocket v. third-party libraries such as Starscream) capabilities across recent versions, market share, and optimal cutoff version. Experiment on native websocket and assess deficiencies. Research on Swift Package Manager v. Cocoapods for managing external dependencies. Review, build, and test new iOS code (#35). Manage and debug on iOS provisioning profiles, signing certificate requests, and distribution certificate. Debug and fix issues related to x.country redirects and email alias contract management.

2023-10-17 Tue (2.5h): Testflight fine-grained access, profile, certificate setup. Build and publish new versions. Test latest demos and debug. Voice provider API testing and debug.

2023-10-16 Mon (3.5h): Review code update (#25, #28), all progress updates and results. Debugging Swift dashboard UI mockup bugs, Swift extensions.
Review and test Swift UI mockup fixes. Review code updates (#26 willow e2e, #28 Safari support, #10 error handling, deployment fixes), recent demos
Review, test, and compare Swift websocket libraries and code. Code review #4 (audio player base, elevenlabs), #25 (gpt4 context and deepgram), #26 (voice detection), #27 (willow e2e) and related components. Test commercial TTS provider APIs.

---

2023-10-14 Sat: (2h) TestFlight build, launch, bug fixes, and configurations. Review Deepgram benchmark and documentations.

2023-10-13 Fri: (7h) Research and analysis on audio libraries and frameworks under react native and iOS native system (CoreAudio, AVFoundation), [write ups](https://github.com/harmony-one/x/blob/main/doc/audio.md), [boilerplate app setup](https://github.com/harmony-one/x/pull/21), and code review. Progress review. X app configuration, framework imports, permission updates. Manual x.country domain management, maintainer updates. Long-term renewal, and bug fixes.

2023-10-12 Thu: (1.5h) Research on AVFoundation, Apple audio session programming, web audio controls, react-native sound and expo AV.

2023-10-11 Wed: (5.5h) Code review and discussion of contributor all historical commits. Manual subdomain record management. Discussions on findings of Twilio voice, voice models, performance, technical limitations, and streaming techniques and capabilities. Analyze use cases, engineering requirements, product prioities, development plans. Research on Apple GPU and Metal inference capbility, on-device APIs, and performance.

2023-10-10 Tue: (1.5h) Deepgram review. Twilio voice review and research.

2023-10-09 Mon: (0.5h) General code review. Research note and documentation reivew. React native app setup and Test Flight configuration.

---

2023-10-08 Sun: (2h) Research, analysis and discussion on model size, distribution mode, hybrid deployment, performance trade off, edge device benchmark, and real-time factors. Research on Whisper streaming workaround. Analysis of performance and practicality of wav2vec2.

2023-10-06 Fri: (1h) Voice cloning and synthesis experimentation, note review. Revisiting Huggingface experiments.

2023-10-05 Thu: (3.5h) Research on Whisper, paper and notes, performance data in practice, and related speech recognition development. Research on vector database. Kibana reconfiguration on payment analytics. x.country expiration issue, manual, renewal and general .country maintainer permission update.

2023-10-04 Wed: (2.5h) Discussion and analysis on voice product, tech stacks, and use cases. Task planning and work allocation. Speech model performance review. Research on Twilio voice streaming.

2023-10-03 Tue: (5h) Personalized task planning. Huggingface models and spaces experimentation (tortoise, coqui, others) . Ad-hoc performance and latency measurements. Domain renewal and functionality technical discussions. ElasticSearch payment statistics code review and discussions. Discussions on voice related hugginface AI models, benchmark, and possible tasks. GCP Vertex AI permission settings and service account. Experiment with commercial XTTS and TTS models.

2023-10-02 Mon (1h): Bot analytics reporting permission setup. Data export. Discussion and bot code review on payment amount capturing

---

2023-09-29 Fri: (6h) Bug fixes on trasient bot state for analytics. End-to-end testing. Research and experiments on state of the art speech related models, performance metrics, pratical experience, and use cases. Analysis and discussion on Whatsapp business platform and bot feasibility.

2023-09-28 Thu: (4h) Fix time measurement issues, type issues, and compile issues with the bot. Kibana dashboard update, raw log view setup, and version rolling. Testing end-to-end and data analytics. Review analytics data. Review context and session constructions in grammY. Move request-based transient data to appropriate places Fix issues with negative time measurement for good.

2023-09-27 Wed: (4h) Discussions on bot, voice AI products, technical limitations, and use cases.

2023-09-26 Tue: (1h) Research on voice AI state of the art demos and improvements (tortoise, coqui, bark, fastspeech, naturalspeech, promptts, and others).
