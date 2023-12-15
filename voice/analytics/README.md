## Table of Content
[Overview](https://github.com/harmony-one/x/blob/main/voice/analytics/README.md#overview) \
[Beginner Guide](https://github.com/harmony-one/x/edit/main/voice/analytics/README.md#beginner-guide) \
[Log Interpreter](https://github.com/harmony-one/x/edit/main/voice/analytics/README.md#log-interpreter) 

## Overview
all_stats currently pulls the following from the last 24 hours
```
GPT Stats from Elastic Search
  Number of response tokens used
  Number of request tokens used
  Estimated cost
  Number of queries
  Average first response time
  Average total response time

App error stats from Sentry
  Number of errors in production (currently omitting handleRecognitionError)
```

word_clou_generator.py generates a word cloud of most commonly used words in user queries from the last 24 hours. It omits commonly used non-meaningful words. This gives a quick overview of usage type. 

## Beginner Guide
To install necessary libraries
```
pip install -r requirements.txt
```

After installation is complete, reach out for the nessisary .env file. This file contains all necessary keys and other enviroment variables. 

Put the .env in the same folder as the rest of the Python files. File structure should look as following
```
.
├── README.md
├── .env
├── all_stats.py
├── openai_stats.py
├── requirements.txt
├── sentry_data.py
└── word_cloud_generator.py
             
```

Then to run
```
python3 all_stats.py
```

To run `word_cloud_generator.py` as is, the font pack `arial-unicode-ms.ttf` must be in the same directory as well to handle non-latin character languages. You can find a download [here](https://www.download-free-fonts.com/details/88978/arial-unicode-ms)

## Log Interpreter
Run the following command from inside the analytics directory to get a parsed version of the log file titled `parsed_transcript.txt`.
```
python3 log_interpreter.py \path\to\transcript\text-44E9-BF84-7B-0.txt
```
