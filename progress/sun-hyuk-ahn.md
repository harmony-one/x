2023-10-17 Tue: Benchmarked latencies for various speech to text API. Deepgram [outperforms](https://www.notion.so/harmonyone/API-Benchmark-f3bee005a3aa4e4eb302ad02647a3d8b?pvs=4) others by far. Fixed ElevenLabs issue "webapp" was having. Had a meeting with Ivan to prioritize tasks, we will work on benchmarking latency percentage for the end-to-end flow.

2023-10-16 Mon: Updated the app to support iOS compatibility on Safari, which will become the main browser for /sam. Began setting up Prometheus to measure time lapsed on key components of the app (DeepGram, ChatGPT, and ElevenLabs).

---

2023-10-13 Fri: Deployed voice-webapp on [sun.x.country](sun.x.country). Working on integrating with Ivan's Acapela to the voice-webapp. Looking for various areas of optimization.

2023-10-12 Thu: Studying and going over Hugging Face [Quantization](https://huggingface.co/docs/transformers/main_classes/quantization); Wrestling [GPTQ](https://arxiv.org/pdf/2210.17323.pdf) paper (still need time to fully digest the material); Building demo 8-bit GTPQ (referenced from this [repo](https://github.com/IST-DASLab/gptq)); will continue working on this tomorrow

2023-10-11 Wed: Set up access and permission to supercomputing infrastructure with GPUs (for Ivan); Set up access and permission to Picovoice Rhino benchmark testing; Benchmarked the following NLU models: Picovoice Rhino, Google Dialogflow, Amazon Lex; Picovoice Rhino outperforms the other mentioned models by ~30% average
