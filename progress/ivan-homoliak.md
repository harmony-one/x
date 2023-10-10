


## Week 41

**9/10/23 (Monday)**
- Investigating how to use Apple Neural Engine (ANE). 
  
  - The most related is library using ANE - [Speech Synthesis](https://developer.apple.com/documentation/avfoundation/speech_synthesis "smartCard-inline"), which we can consider when developing iOS app.

   - Interesting project is also Acapella, see [demos](https://www.acapela-group.com/demos/ "smartCard-inline").
 
- Investigated cloud API of [Acapela](https://www.acapela-group.com/demos/)
  -  work impressively fast,

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






## Week 40 

**7/10/23 (Sat)**
- Testing Meta's Seamless MT4
  - It enables Automatic Speech Recognition, which might be usefull.

  - Did exps with HuggingFace model installed locally (https://huggingface.co/spaces/facebook/seamless_m4t):
    - on PC (CPU-only was pretty slow)
    - by default, runs as a local web service - easy to use HTTP API  

    - It is not precise when using T2ST. I tried (auto encoding setting) english to english and it replaced “speach” by “speak”.

    - Also, it was not very precise with translation to slovak - added some strange (uttered) word at the end of sentence. Use wrong form of the particular word multiple (viacerych/viacero.) It is written correctly in the output, but synthesis is wrong. 
    - The same hold for Czech language - synthetizing the different format of word (komunit/komunita).

**6/10/23 (Fri)**
- Investigating options to increase quota in supercomputing centre and make 2 applications to get access into 2 different infrastructures with GPUs, we need soon. 
- Read the [paper](https://arxiv.org/pdf/2109.08710.pdf) from Apple people, how to do the on-device S2T and T2S with custom modifications of Tacotron and WaveRNN. No source code available and very likely using Apple Neural Engine (ANE), although not mentioned in the paper.
- Testing **callannie**.
  - it cannot sing
  - contains a lot of boilerplate at the beginning of questions (maybe to intentionaly get time to process requests)
  - transcriptions are not real-time, as she says, but they are available pretty fast after the end of calls.
  - it does not support proper pronautiation of foreign languages (Tested slovak and Czech) and it is just english speaker reading it with english accent.

**5/10/23 (Thu)**
- Investigating Suno's Bark, making tests measuring the [performance](https://docs.google.com/spreadsheets/d/19K1Z4wuYO1eUxwAzibDi4KdvOYjIWkoMsai8dqHaOXE/edit#gid=0) on local devices - notebook, PC. 
- Applying for supercomputing access - it is a bit annoying and required some overhead to pass a few tutorials how to build the correct Openstack machine and setup correct security groups to allow remote ssh, etc. It works now, but the problem is the missing GPU hardware (quotas) in my account.
- Testing callannie.
- Was thinking about **a list of AI-challenging tasks to test it performance**. Inspired by [Bard](https://bard.google.com/share/a0169941d76e)
  1. Generating different creative text formats of text content, like poems, code, scripts, musical pieces, email, letters, etc.
  2. Singing
  3. Prosessing non-trivial requests about Internet sources - aggregating some data; not just a simple parsing of the web page and summary.
  4.  Keeping up to date with the Internet content and capability of responding on queries related to new content (news, events, announcements)
  5. Understanding and responding to challenging or strange questions. E.g., what could happen if one month would take as long as one day? What mainstream media content showed to be incorrect as opposed to alternative webs and media?
  6.  T2S: Pronaunciation of different languages (even singing in different languages). S2T: Parsing the songs, raps, etc.

**4/10/23 (Wed)**
- Getting familiar with open source Coqui models and repo https://github.com/coqui-ai. They are pushing a lot VITS model. It can even sing.
  

**3/10/23 (Tue)**
- Getting familiar with Harmony's goals and projects to focus on.
- Playing with picovoice. For Speech-to-Intent it is using their Rhino engine, which outperforms other engines.
- Setting up the environment - installing python  AI dependencies to play in virtual python environment (venv); clearing storage.

**2/10/23 (Mon)**
- Getting familiar with Harmony's CompoundV2 repository and in general how CompoundV2 works. 
- Call with Theo F.


