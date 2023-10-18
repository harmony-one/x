import React, {useEffect, useState} from 'react'
import {Box, Select, Text} from "grommet";
import useDebounce from "../../hooks/useDebounce";
import {
  SpeechModel,
  SpeechModelAlias,
  DeepgramResponseResults,
  DeepgramResponseMetadata
} from "./types";
import {VoiceActivityDetection} from "../VoiceActivityDetection/VoiceActivityDetection";


const DeepgramApiKey = String(process.env.REACT_APP_DEEPGRAM_API_KEY)
const SpeechWaitTimeout = 200


export interface ISpeechToTextWidget {
  onReady: () => void
  onChangeOutput: (output: string) => void;
}

const getMediaRecorder = (stream: MediaStream): MediaRecorder => {
  const supported_types = ["audio/webm", "video/mp4"];

  const findSupportedType = (types: string[]): string | undefined => {
    return types.find((type) => MediaRecorder.isTypeSupported(type));
  };

  const supportedType = findSupportedType(supported_types);

  if (!supportedType) {
    throw new Error("No suitable mimetype found for this device");
  }

  const options = { mimeType: supportedType };
  return new MediaRecorder(stream, options);
};

export const SpeechToTextWidget = (props: ISpeechToTextWidget) => {
  const [currentSocket, setCurrentSocket] = useState<WebSocket>()
  const [selectedModel, setSelectedModel] = useState(SpeechModel.nova2)
  const [isSpeechEnded, setSpeechEnded] = useState(false)
  const [transcriptions, setTranscriptions] = useState<string[]>([])
  const [mediaStream, setMediaStream] = useState<MediaStream | null>(null)

  const debouncedTranscriptions = useDebounce(transcriptions, SpeechWaitTimeout)

  const onTranscribeReceived = (data: DeepgramResponseResults) => {
    const { transcript, confidence } = data.channel.alternatives[0]
    console.log('onTranscribeReceived:', transcript, 'confidence:', confidence)

    const startMs = Math.round(data.start * 1000);
    const durationMs = Math.round(data.duration * 1000);
    const endMs = Math.round((data.start + data.duration) * 1000);

    if(transcript.length > 0) {
      console.log('Deepgram response:', data)
      // console.log('startMs', startMs, 'durationMs', durationMs, 'endMs', endMs)
    } else {
      // console.log('durationMs', durationMs)
    }

    if(transcript.length > 0) {
      if(confidence >= 0.6) {
        setTranscriptions(transcriptions => [...transcriptions, transcript])
      } else {
        console.warn('Transcription ignored, low confidence')
      }
    }
    setSpeechEnded(transcript.length === 0)
    // console.log('Is speech ended:', transcript.length === 0, transcript)
  }

  useEffect(() => {
    if(transcriptions.length > 0 && isSpeechEnded) {
      const text = transcriptions.join(' ')
      props.onChangeOutput(text)
      setTranscriptions([])
      console.log('STT transcription: ', text)
    }
  }, [debouncedTranscriptions, isSpeechEnded]);

  useEffect(() => {
    if(DeepgramApiKey && selectedModel) {
      navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
       var mediaRecorder: MediaRecorder
        try {
          mediaRecorder = getMediaRecorder(stream)
        } catch (error) {
          if (error instanceof Error) {
            console.error("An error occurred while creating MediaRecorder:", error.message);
          } else {
            console.error("An unexpected error occurred:", error);
          }
          return
        }

        if(currentSocket) {
          currentSocket.onmessage = () => {}
        }
        setMediaStream(stream)
        const socket = new WebSocket(
          `wss://api.deepgram.com/v1/listen?model=${selectedModel}`,
          [ 'token', DeepgramApiKey ]
        )
        console.log('\n\n\nInit Deepgram STT API model:', selectedModel, '\n\n\n')

        socket.onopen = () => {
          mediaRecorder.addEventListener('dataavailable', event => {
            socket.send(event.data)
          })
          mediaRecorder.start(250)
        }

        socket.onmessage = (message) => {
          const data = JSON.parse(message.data) as (DeepgramResponseResults | DeepgramResponseMetadata)
          if(data.type === 'Results') {
            onTranscribeReceived(data)
          }
        }
        setCurrentSocket(socket)
      })
    }
  }, [DeepgramApiKey, selectedModel]);

  const modelsOptions = Object.values(SpeechModel).map(value => {
    return {
      value,
      alias: SpeechModelAlias[value]
    }
  })

  return <Box>
    <Box direction={'row'} align={'baseline'} gap={'16px'}>
      <Box>
        <Text>Speech-to-Text</Text>
      </Box>
      <Box width={'260px'}>
        <Select
          size={'small'}
          value={modelsOptions.find(option => option.value === selectedModel)}
          options={modelsOptions}
          labelKey={'alias'}
          onChange={({ option }) => setSelectedModel(option.value)}
        />
      </Box>
    </Box>
    <Box margin={{ top: '16px' }} direction={'row'} align={'center'} gap={'32px'}>
      <Box
        width={'100%'}
        height={'120px'}
        round={'6px'}
        pad={'8px'}
        style={{
          border: '1px solid gray',
          overflowY: 'scroll',
          fontSize: '20px',
          color: '#12486B'
        }}
      >
        {transcriptions.join(' ')}
      </Box>
    </Box>
    <Box>
      <VoiceActivityDetection mediaStream={mediaStream} />
    </Box>
  </Box>
}
