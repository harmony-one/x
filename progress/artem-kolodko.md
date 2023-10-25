2023-10-25 Wed: Started working on payments for X app: refactoring DB schema in [stripe-payments-backend](https://github.com/harmony-one/stripe-payments-backend) to support free credits, adding new Stripe payment intent event handler to support Apple Pay (work in progress)

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

