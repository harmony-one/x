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

conversation_router = ConversationRouter(
    agent_thunk=lambda: ChatGPTAgent(
        ChatGPTAgentConfig(
            initial_message=BaseMessage(text="Hello!"),
            prompt_preamble="Have a pleasant conversation about life",
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
            output_audio_config, voice_name="en-US-SteffanNeural"
        )
    ),
    logger=logger,
)

app.include_router(conversation_router.get_router())
