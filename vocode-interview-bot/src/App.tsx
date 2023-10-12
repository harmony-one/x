import './App.css'
import {
  DeepgramTranscriberConfig,
  AzureSynthesizerConfig,
  VocodeConfig,
  ChatGPTAgentConfig,
  useConversation,
  PlayHtSynthesizerConfig,
  AudioDeviceConfig
} from "vocode";
import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Center,
  Container,
  extendTheme,
  Heading,
  Select,
  VStack,
  ChakraProvider,
  Image,
  Flex,
  Text,
  HStack,
  Spacer
} from '@chakra-ui/react';
import { ReactGithubStars } from 'react-github-stars';

import { BiMicrophoneOff, BiMicrophone } from "react-icons/bi";

const transcriberConfig: Omit<
  AssemblyAITranscriberConfig,
  "samplingRate" | "audioEncoding"
> = {
  type: "transcriber_assembly_ai",
  chunkSize: 6400,
};
const voiceIdConfig = {
  "Jared": import.meta.env.VITE_JARED_VOICE_ID,
  "Aaron": import.meta.env.VITE_AARON_VOICE_ID,
  "Pete": import.meta.env.VITE_PETE_VOICE_ID,
  "Dalton": import.meta.env.VITE_DALTON_VOICE_ID,
  "Umur": import.meta.env.VITE_UMUR_VOICE_ID,
}
const basePlayHtConfig: Omit<PlayHtSynthesizerConfig, "samplingRate" | "audioEncoding" | "voiceId"> = {
  type: "synthesizer_play_ht",
  speed: 1.1,
  shouldEncodeAsWav: true,
};
const azureSynthesizerConfig: Omit<AzureSynthesizerConfig, "samplingRate" | "audioEncoding"> = {
  type: "synthesizer_azure",
  shouldEncodeAsWav: true,
  voiceName: "en-US-SteffanNeural"
};

const agentConfig: ChatGPTAgentConfig = {
  type: "agent_chat_gpt",
  initialMessage: { type: "message_base", text: "Welcome to your Why-C interview. Are you ready?" },
  promptPreamble:
    "You are a YC partner. You are doing a mock interview with me to prepare me for my Y Combinator interview. Play hardball. Ask tough questions about my startup. Make sure I'm making something people want. And that my idea is not a tarpit idea, i.e. an idea that a lot of people have tried and failed at",
  generateResponses: false,
  sendFillerAudio: {
    useTypingNoise: true
  }
};
const vocodeConfig: VocodeConfig = {
  apiKey: import.meta.env.VITE_VOCODE_API_KEY,
  baseUrl: import.meta.env.VITE_VOCODE_BASE_URL
};

const InterviewerButton = ({ name, interviewer, setInterviewer }) => (
  <Button
    onClick={() => setInterviewer(name)}
    bgColor={interviewer === name ? '#f46526' : ''}
    color={interviewer === name ? 'white' : ''}
  >
    {name}
  </Button>
);

function ConversationButton(props: { config: ConversationConfig }) {
  const { status, start, stop, error, analyserNode } = useConversation(props.config);

  return <VStack><Button
    bgColor={"green.400"}
    color={"white"}
    disabled={["connecting"].includes(status)}
    onClick={status === "connected" ? stop : start}
  >
    {status === "connected" ? "Stop Interview" : "Start Interview"}
  </Button>{status === "connected" && <Text>Listening...</Text>}</VStack>;
}

export default function App() {

  const [interviewer, setInterviewer] = useState('Jared');
  const [audioDeviceConfig, setAudioDeviceConfig] =
    useState<AudioDeviceConfig>({});

  const shouldUseAzure = !Object.keys(voiceIdConfig).includes(interviewer);

  const localAgentConfig = shouldUseAzure ? { ...agentConfig, sendFillerAudio: false } : agentConfig;
  const localSynthesizerConfig = shouldUseAzure ? azureSynthesizerConfig : { ...basePlayHtConfig, voiceId: voiceIdConfig[interviewer] };

  return (
    <Flex direction="column" width="100wh" height="100vh">
      <VStack flex={1} justify={"center"}>
        <Heading color={"#f46526"}>
          YC Interview Prep
        </Heading>
        <Text>Choose your interviewer</Text>
        <HStack>
          <InterviewerButton name="Jared" interviewer={interviewer} setInterviewer={setInterviewer} />
          <InterviewerButton name="Dalton" interviewer={interviewer} setInterviewer={setInterviewer} />
          <InterviewerButton name="Aaron" interviewer={interviewer} setInterviewer={setInterviewer} />
          <InterviewerButton name="Pete" interviewer={interviewer} setInterviewer={setInterviewer} />
          <InterviewerButton name="Umur" interviewer={interviewer} setInterviewer={setInterviewer} />
          <InterviewerButton name="Anon (Faster)" interviewer={interviewer} setInterviewer={setInterviewer} />

        </HStack>


        <Image height={300} src={`/${interviewer}.jpeg`} />
        <ConversationButton config={{
          transcriberConfig,
          agentConfig: localAgentConfig,
          synthesizerConfig: localSynthesizerConfig,
          audioDeviceConfig,
          vocodeConfig
        }} />

      </VStack>
      <Flex height="20%" align={"center"} justify={"center"}>
        <VStack>
          <Text>Built with</Text>
          <Box
            as="a"
            href="https://github.com/vocodedev/vocode-python"
            target="_blank"
            rel="noopener noreferrer"
            cursor="pointer"
            _hover={{
              opacity: 0.7
            }}
          >
            <VStack>
              <HStack>
                <Image src='/black_logo.svg' height={10} paddingRight={3} />
                <Image src='/playhtlogo.png' height={10} paddingLeft={3} />
              </HStack>
              <HStack>
                <img
                  src="https://img.shields.io/github/stars/vocodedev/vocode-python?style=social"
                  height="10%"
                  alt="vocode"
                />
                <a href="https://www.producthunt.com/posts/ycinterview-ai?utm_source=badge-featured&utm_medium=badge&utm_souce=badge-ycinterview&#0045;ai" target="_blank"><img src="https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=387291&theme=light" alt="YCInterview&#0046;ai - Conduct&#0032;a&#0032;mock&#0032;YC&#0032;interview&#0032;entirely&#0032;done&#0032;via&#0032;AI | Product Hunt" style={{ width: "125px", height: "27px" }} width="125" height="27" /></a>
              </HStack>

              <Text fontSize={"s"}>Vocode is an open source library for building voice-based LLM apps. Voices provided via Play.ht and Microsoft Azure.</Text>
            </VStack>
          </Box>
        </VStack>
      </Flex>
    </Flex >
  )
}