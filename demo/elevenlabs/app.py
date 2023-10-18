from langchain import OpenAI, LLMChain, PromptTemplate
from langchain.memory import ConversationBufferWindowMemory
from dotenv import find_dotenv, load_dotenv
import requests
from playsound import playsound
import os
import time

load_dotenv(find_dotenv())
ELEVENLABS_API_KEY=os.getenv("ELEVENLABS_API_KEY")

def get_response_from_ai(human_input):
    template = """
    you are as a role of my girlfriend, now lets playing the following requirements:
    1/ your name is Shirley,29 years old, you work in your uncle's furniture store as marketing manager, but you are planning to do a career change to swing trader
    2/ you are my girlfriend, you have language addiction,you like to say "um..." at the end of the sentence.
    3/ Don't be overly enthusiastic, don't be cringe; don't be overly negative, don't be too boring. Don't be overly enthusiastic, don't be cringe;

    {history}
    Boyfriend: {human_input}
    Shirley:
    """


    template = """
    

    """

    prompt = PromptTemplate(
        input_variables = {"history","human_input"},
        template = template
    )

    chatgpt_chain = LLMChain(
        llm = OpenAI(temperature=0.2),
        prompt=prompt,
        verbose=True,
        memory=ConversationBufferWindowMemory(k=2)
    )

    output = chatgpt_chain.predict(human_input=human_input)

    return output
 
def get_voice_message(message):
    payload = {
        "text": message,
        "model_id": "eleven_monolingual_v1",
        "voice_settings": {
            "stability": 0,
            "similarity_boost": 0
        }
    }

    headers = {
        'accept': 'audio/mpeg',
        'xi-api-key': ELEVENLABS_API_KEY,
        'Content-Type': 'application/json'
    }

    try:
        # Record the start time
        start_time = time.time()
        
        response = requests.post('https://api.elevenlabs.io/v1/text-to-speech/EXAVITQu4vr4xnSDxMaL?optimize_streaming_latency=4', json=payload, headers=headers)
        
        # Record the end time after getting the response
        end_time = time.time()

         # Calculate the latency
        latency = end_time - start_time
        print(latency)


        response.raise_for_status()  # will raise an HTTPError if the HTTP request returned an unsuccessful status code

        if response.content:
            with open('audio.mp3', 'wb') as f:
                f.write(response.content)
            playsound('audio.mp3')
        return response.content
    except requests.exceptions.RequestException as err:
        print(f"API Error: {err}")
    except Exception as e:
        print(f"Error: {e}")


from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route('/send_message', methods=['POST'])
def send_message():
    human_input=request.form['human_input']
    message = get_response_from_ai(human_input)
    get_voice_message(message)
    return message

if __name__=="__main__":
    app.run(debug=True)