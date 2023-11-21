2023-11-15 - 2024-01-15: Time off for personal research work.

2023-11-08 Wed: Meeting with Speech group at BUT. Discussed various speach to text topics. Studied some speach to text related papers and text to speech presentation from Brno University of Technology. Tested Vocie AI app. (Worked for 4 hours)

---

**2023-11-02 Thu:**
Continue in IOS app development and setup of virtualized OS X. Studying related tutorials. 

**2023-11-01 Wed:**
Looking into IOS app development on virtualized OS X. Studying related tutorials. Configured TestFlight with Voice IA App on Iphone 15 - testing.

**2023-10-31 Tue:**
Continue on getting into Android development with Kotlin. Changed focus to IOS app development with the local model. Preparing development environment in Virtualbox - installed OS X Monteray (since Ubuntu does not have a proper tool set for IOS development).
 

**2023-10-30 Mon:**
Studying management of secret keys (such as API keys) in mobile Apps across open source project in Github (involving iOS and Android). Studied also OWASP for mobile applications as well as some community discussions and articles.

---

**2023-10-27 Fri:**
Getting familiar with development of swift and studying Aaron's code.

**2023-10-26 Thu:**
Starting development of Android App with the focus on Android 31+, which has support for the newest Neural Network API enabling 8-bit quantization (and thus more efficient utilization of GPU, but covering on 51% of devices). Studying  [Sherpa](https://github.com/Bip-Rep/sherpa/tree/1.0.0) that works with Meta's llama model (7B) - installed locally. (Worked only 4hrs)


**2023-10-25 Wed:**
Continue in local deployment and testing of small models on CPU-based machine - gpt4all, vLLM. Studying features of [LLMFarm](https://github.com/guinmoon/LLMFarm) that can be used on IOS 16+. Pasivelly reviewing recent PRs from Aaron. (Worked only 4hrs)

**2023-10-24 Tue:**
Configuring new GPU server for OLLAMA models - installing nvidia + CUDA. Enabled REST API and exposed a few models outside. Checking how to do HTTPS authentication in OLLAMA project. Debugging the bigger models than 13B sometime stuck and keep zombie processes that cannot be killed. 


**2023-10-23 Mon:**
Deploying and configuring Mistral 7B locally on GPU server with pytorch. It takes 5mins to initiates the 14GB model and memory utilization peaks at 32GBs (after init, it consumes only 1GB) - their exhauts resources even on GPU server. Found other tools/libraries with small LLM models [vLLM](https://vllm.readthedocs.io/en/latest/models/supported_models.html) and [OLLAMA](https://ollama.ai/library). OLLAMA's Mistral 7B takes 3 seconds to init (on CPU or GPU machines) and provides output in 0.1-0.5s (on GPU) and 1-3s on CPU. 

---

**2023-10-20 Fri:**
Debugging vocode REACT app. Studied REACT documentation. Configured Let's encrypt certificate for development Willow inference server - however, not on our GPU server - waiting on Sun to assign domain name to it or give me access to cloud configuration. Testing Yuriy's demo.


**2023-10-19 Thu:**
 Created Azure speech account to get API key. Deployed streaming conversation library of vocode python backend locally and bound to vocode-demo (the same we have in our X repo). This library was having errors when using their API.  Also, I had to switch to newer Ubuntu since node had some unresolvable conflicts. Continue in getting familiar with React + ts.


**2023-10-18 Wed:**
Getting familiar with REACT and vocode demo. Installed vocode backend service locally and tried to bound our demo on it. Reviewed some PRs from Yuriy.

**2023-10-17 Tue:**

Testing the biggest model (5GB) of Whisper in WIS - the quality of STT was subjectivelly improved. Synced with Sun what to focus on - performance measurement of Artem's demo pipline (started to work on it). Studied code of WIS, and found that it uses Microsoft's [5T model](https://huggingface.co/microsoft/speecht5_tts) from Hugging Face as well as [vocoder](https://huggingface.co/microsoft/speecht5_hifigan).
Can be replaced with any other TTS from [HF](https://huggingface.co/models?pipeline_tag=text-to-speech&library=pytorch&sort=likes) with a bit of coding.

**2023-10-16 Mon:**

Configuring chatbot of Willow Inference Server. It can load any chatbot model from HuggingFace and access through the REST API. Fixing some bugs.

---

**2023-10-13 Fri:**

- Tested Acapela with Neural voices processing (including HTTP overhead) achieved ~3x speed up. Updated [Notion page](https://hill-baron-ebd.notion.site/Acapela-STT-26e27193c8534b6cb7af7db37bf925a8?pvs=4).
- Configured CORS for WIS. Tested within our GitHub repo ./willow-js-demo/
- Onboarding stuff (setup email ivan@harmony.one + Notion with it; Lastpass)
- Code review of X repo
- Briefly passed report SoTA report form [Air Street Capital](https://docs.google.com/presentation/d/156WpBF_rGvf4Ecg19oM1fyR51g4FAmHV3Zs0WLukrLQ/edit#slide=id.g24daeb7f4f0_0_3373)

**2023-10-12 Thu:**

- Tested **STT** WIS (w. Whisper) performance on cloud machine with GPU Tesla T4 (~16x speed-up). Results were put to previous day.
  - For English, very precise STT (no conversion issues); Slovak language was worse (~10% error rate)
- Tested **TTS** of WIS
  - a couple of issues (30-minutes => 30 skipped; ChatGPT/GPT not-spelled; some words skipped; 600 chars limit of text lenght).
  - I filed a few GitHub [issues](https://github.com/toverainc/willow-inference-server/issues/created_by/ivan-homoliak-sutd) at the WIS repo
- Testing cloud TTS API of Acapela
  - It achieved 10x-20x speed-up
    - Details at [Notion](https://www.notion.so/Acapela-STT-26e27193c8534b6cb7af7db37bf925a8?pvs=4)
    - Acapela replied with offer: 5 euro/hour of generated speech (tax excl).
  - https://gist.github.com/ivan-homoliak-sutd/fa21eb07be9f8a9595b85ad7a39e45c7

**2023-10-11 Wed**

- Installed Willow Inference Server (WIS) on PC with 6 CPU cores (12 hw threads).

  - **STT w. ASR** (Willow w. Whisper / **6 workers/threads**) - **almost 2x speed-up**
    - Some measurements for EN (speech time => infer time) 10820 ms => 7072.576 ms; 13240 ms => 7437.832 ms
    - Measurements with ASR (SK to EN): 13760 ms => 6824 ms; 12840 ms => 7095.519 ms; 11360 ms => 6948 ms; 14780 ms => 7251.815 ms;
  - **STT w. ASR** (Willow w. Whisper **NVIDIA Tesla T4**) - **15-20x speed-up**
    - Some measurements for EN (speech time => infer time): 13560 ms => 813ms; 5500 ms => 339 ms; 19140 ms => 869 ms
    - Measurements with ASR (SK to EN): 9920 ms => 648.18 ms; 17660 ms => 1048 ms; 22160 ms => 1581 ms

- Describing our use case + competitor prices to Acapela with regard to custom pricing.
- Installing WIS on our cloud machine
  - to install WIS:
    (1) Docker needs to be [removed](https://g.co/bard/share/73fa269c3f23)
    (2) removed double-signed repos: _sudo mv /etc/apt/sources.list.d/nvidia-docker.list /tmp/nvidia-docker.list_
  - we put the service on **54.186.221.210:19000** (should work soon)

**2023-10-10 Tue**

- resolved access and permissions to supercomputing infrastructructure with GPUs
  - installed some dependencies, currently some problems with SSL lib of python3
  - [Snippet for testing Suno Bark on different platforms](https://gist.github.com/ivan-homoliak-sutd/4be715812314668603ac780c72f11f04)
- getting familiar with the Harmony's current repository
  - involving getting a bit more into React and TS (with the help of AI in VS code)
- starting to play with Acapela API (python)

**2023-10-9 Mon**

- Investigating how to use Apple Neural Engine (ANE).

  - The most related is library using ANE - [Speech Synthesis](https://developer.apple.com/documentation/avfoundation/speech_synthesis "smartCard-inline"), which we can consider when developing iOS app.

  - Interesting project is also Acapella, see [demos](https://www.acapela-group.com/demos/ "smartCard-inline").

- Investigated cloud API of [Acapela](https://www.acapela-group.com/demos/)

  - work impressively fast,

  - my custom text of demo in Czech is 3x faster than 11Labs; for English, 2x faster

  - Czech language sounds realistic

  - 1min of synthetized speech costs 10 euro :-)

  - API supports streaming
  - I’ve sent them email to check whether there is not better pricing for commercial projects.

- Investigated **ElevenLabs** voice synthesis API
  - It looks a bit slow in demos (tested also for Czech) - definitelly not enough for real-time processing. Maybe with the premium subscription it will be faster, since it is alegedly used in callannie.
  - Supports streaming.
  - Pricing is friendly:
    - 100$ per 10 hrs of synthetized text
    - 330$ per 40 hrs

---

## Week 40

**2023-10-7 Sat**

- Testing Meta's Seamless MT4

  - It enables Automatic Speech Recognition, which might be usefull.

  - Did exps with HuggingFace model installed locally (https://huggingface.co/spaces/facebook/seamless_m4t):

    - on PC (CPU-only was pretty slow)
    - by default, runs as a local web service - easy to use HTTP API

    - It is not precise when using TTST. I tried (auto encoding setting) english to english and it replaced “speach” by “speak”.

    - Also, it was not very precise with translation to slovak - added some strange (uttered) word at the end of sentence. Use wrong form of the particular word multiple (viacerych/viacero.) It is written correctly in the output, but synthesis is wrong.
    - The same hold for Czech language - synthetizing the different format of word (komunit/komunita).

**2023-10-6 Fri**

- Investigating options to increase quota in supercomputing centre and make 2 applications to get access into 2 different infrastructures with GPUs, we need soon.
- Read the [paper](https://arxiv.org/pdf/2109.08710.pdf) from Apple people, how to do the on-device STT and TTS with custom modifications of Tacotron and WaveRNN. No source code available and very likely using Apple Neural Engine (ANE), although not mentioned in the paper.
- Testing **callannie**.
  - it cannot sing
  - contains a lot of boilerplate at the beginning of questions (maybe to intentionaly get time to process requests)
  - transcriptions are not real-time, as she says, but they are available pretty fast after the end of calls.
  - it does not support proper pronautiation of foreign languages (Tested slovak and Czech) and it is just english speaker reading it with english accent.

**2023-10-5 Thu**

- Investigating Suno's Bark, making tests measuring the [performance](https://docs.google.com/spreadsheets/d/19K1Z4wuYO1eUxwAzibDi4KdvOYjIWkoMsai8dqHaOXE/edit#gid=0) on local devices - notebook, PC.
- Applying for supercomputing access - it is a bit annoying and required some overhead to pass a few tutorials how to build the correct Openstack machine and setup correct security groups to allow remote ssh, etc. It works now, but the problem is the missing GPU hardware (quotas) in my account.
- Testing callannie.
- Was thinking about **a list of AI-challenging tasks to test it performance**. Inspired by [Bard](https://bard.google.com/share/a0169941d76e)
  1. Generating different creative text formats of text content, like poems, code, scripts, musical pieces, email, letters, etc.
  2. Singing
  3. Prosessing non-trivial requests about Internet sources - aggregating some data; not just a simple parsing of the web page and summary.
  4. Keeping up to date with the Internet content and capability of responding on queries related to new content (news, events, announcements)
  5. Understanding and responding to challenging or strange questions. E.g., what could happen if one month would take as long as one day? What mainstream media content showed to be incorrect as opposed to alternative webs and media?
  6. TTS: Pronaunciation of different languages (even singing in different languages). STT: Parsing the songs, raps, etc.

**2023-10-4 Wed**

- Getting familiar with open source Coqui models and repo https://github.com/coqui-ai. They are pushing a lot VITS model. It can even sing.

**2023-10-3 Tue**

- Getting familiar with Harmony's goals and projects to focus on.
- Playing with picovoice. For Speech-to-Intent it is using their Rhino engine, which outperforms other engines.
- Setting up the environment - installing python AI dependencies to play in virtual python environment (venv); clearing storage.

**2023-10-2 Mon**

- Getting familiar with Harmony's CompoundV2 repository and in general how CompoundV2 works.
- Call with Theo F.

---

1-month trial onboarding: 10/1 Sun - 10/31 Tue.
https://www.linkedin.com/in/ivan-homoliak-381117185/
https://scholar.google.com/citations?user=5PQo5gQAAAAJ&hl=en&oi=ao
