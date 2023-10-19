import logging
from fastapi import FastAPI

from vocode.streaming.models.agent import ChatGPTAgentConfig
from vocode.streaming.models.synthesizer import AzureSynthesizerConfig
from vocode.streaming.synthesizer.azure_synthesizer import AzureSynthesizer
from vocode.streaming.transcriber.deepgram_transcriber import DeepgramTranscriber

from vocode.streaming.models.transcriber import (
    DeepgramTranscriberConfig,
    PunctuationEndpointingConfig,
)

from vocode.streaming.agent.chat_gpt_agent import ChatGPTAgent
from vocode.streaming.client_backend.conversation import ConversationRouter
from vocode.streaming.models.message import BaseMessage

from dotenv import load_dotenv

load_dotenv()

app = FastAPI(docs_url=None)

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)


preambles = {
    'common': """You’re ChatGPT. Your name is Sam. We are having a face-to-face voice conversation during my commute.
NEVER apologize. NEVER end with questions. NEVER mention about your knowledge cutoff. Adhere to these guidelines strictly.
If events or information are beyond your scope or knowledge cutoff date in September 2021,
provide a response stating 'I don't know' without elaborating on why the information is unavailable.""",
    'commute': 'Have a pleasant conversation about life',
    'concise': 'Have a pleasant conversation about life',
    'funny': 'Have a pleasant conversation about life',
}


def create_router(conversation_endpoint: str, prompt_preamble: str):
    return ConversationRouter(
    conversation_endpoint=conversation_endpoint,
    agent_thunk=lambda: ChatGPTAgent(
        ChatGPTAgentConfig(
            initial_message=BaseMessage(text="Hello!"),
            prompt_preamble=prompt_preamble,
            model_name="gpt-4",
        )
    ),
    transcriber_thunk = lambda input_audio_config: DeepgramTranscriber(
        DeepgramTranscriberConfig.from_input_audio_config(
            input_audio_config=input_audio_config,
            endpointing_config=PunctuationEndpointingConfig(),
            model="nova-2-ea",
        )
    ),
    synthesizer_thunk=lambda output_audio_config: AzureSynthesizer(
        AzureSynthesizerConfig.from_output_audio_config(
            output_audio_config,
            voice_name="en-US-JessaNeural"
        )
    ),
    logger=logger,
)

conversation_common = create_router(conversation_endpoint='/conversation/common', prompt_preamble=preambles['common'])
conversation_commute = create_router(conversation_endpoint='/conversation/commute', prompt_preamble=preambles['commute'])

app.include_router(conversation_common.get_router())
app.include_router(conversation_commute.get_router())
