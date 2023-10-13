import React, {useEffect, useState} from 'react'
import {Box} from "grommet";
import useDebounce from "../../hooks/useDebounce";
import {DeepgramResponse} from "./types";

const DeepgramApiKey = String(process.env.REACT_APP_DEEPGRAM_API_KEY)
const SpeechWaitTimeout = 1500

export interface ISpeechToTextWidget {
  onReady: () => void
  onChangeOutput: (output: string) => void;
}

export const SpeechToTextWidget = (props: ISpeechToTextWidget) => {
  const [transcriptions, setTranscriptions] = useState<string[]>([])

  const debouncedTranscriptions = useDebounce(transcriptions, SpeechWaitTimeout)

  useEffect(() => {
    if(transcriptions.length > 0) {
      const text = transcriptions.join(' ')
      props.onChangeOutput(text)
      setTranscriptions([])
      console.log('Send to GPT: ', text)
    }
  }, [debouncedTranscriptions]);

  useEffect(() => {
    if(DeepgramApiKey) {
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
          const received: DeepgramResponse = JSON.parse(message.data)
          const transcript = received.channel.alternatives[0].transcript
          const startTimeStamp = received.start
          const latency = received.duration
          const latencyFormatted = `${latency * 1000}ms`

          // if(received.channel.alternatives[0].words.length) {
          //   console.log('received: ', received)
          //   console.log('start: ', startTimeStamp)
          //   console.log('latency: ', latency)
          //   console.log('end: ', startTimeStamp + latency)
          // }

          if(transcript.length > 0) {
            setTranscriptions(transcriptions => [...transcriptions, transcript])
          }
        }
      })
    }
  }, [DeepgramApiKey]);

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
        {transcriptions.join(' ')}
      </Box>
    </Box>
  </Box>
}
