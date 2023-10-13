import React, {useEffect, useMemo, useState} from 'react'
import {Box} from "grommet";
import useDebounce from "../../hooks/useDebounce";

// Get your key here: https://console.picovoice.ai/
const DeepgramApiKey = String(process.env.REACT_APP_DEEPGRAM_API_KEY)

export interface ISpeechToTextWidget {
  onReady: () => void
  onChangeOutput: (output: string) => void;
}

export const SpeechToTextWidget = (props: ISpeechToTextWidget) => {
  const [transcriptionText, setTranscriptionText] = useState('')
  const [audioDeviceIdState, setAudioDeviceId] = useState<string>('');

  // const debouncedText = useDebounce(transcriptionText, 2000)

  useEffect(() => {
    navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
      const mediaRecorder = new MediaRecorder(stream, { mimeType: 'audio/webm' })
      const socket = new WebSocket('wss://api.deepgram.com/v1/listen?model=nova-2-ea', [ 'token', DeepgramApiKey ])
      socket.onopen = () => {
        mediaRecorder.addEventListener('dataavailable', event => {
          socket.send(event.data)
        })
        mediaRecorder.start(250)
      }

      socket.onmessage = (message) => {
        const received = JSON.parse(message.data)
        const transcript = received.channel.alternatives[0].transcript
        const startTimeStamp = received.start
        const latency = received.duration
        const latencyFormatted = `${latency * 1000}ms`

        if(received.channel.alternatives[0].words.length) {
          console.log('received: ', received)
          console.log('start: ', startTimeStamp)
          console.log('latency: ', latency)
          console.log('end: ', startTimeStamp + latency)
        }

        if(transcript !== transcriptionText) {
          setTranscriptionText(transcript)
          props.onChangeOutput(transcript)
        }
      }
    })
  }, []);

  return <Box>
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
        {transcriptionText}
      </Box>
    </Box>
  </Box>
}
