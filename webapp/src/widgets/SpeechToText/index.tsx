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
  const [isSpeechEnded, setSpeechEnded] = useState(false)
  const [transcriptions, setTranscriptions] = useState<string[]>([])

  const debouncedTranscriptions = useDebounce(transcriptions, SpeechWaitTimeout)

  useEffect(() => {
    if(transcriptions.length > 0 && isSpeechEnded) {
      const text = transcriptions.join(' ')
      props.onChangeOutput(text)
      setTranscriptions([])
      console.log('Send to GPT: ', text)
    }
  }, [debouncedTranscriptions, isSpeechEnded]);

  useEffect(() => {
    if(DeepgramApiKey) {
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

          const startMs = Math.round(received.start * 1000);
          const durationMs = Math.round(received.duration * 1000);
          const endMs = Math.round((received.start + received.duration) * 1000);


          if(transcript.length > 0) {
            console.log(received)
            console.log(startMs, durationMs, endMs)
          } else {
            console.log(durationMs)
          }

          console.log('Is speech ended:', transcript.length === 0)
          if(transcript.length > 0) {
            setSpeechEnded(false)
            setTranscriptions(transcriptions => [...transcriptions, transcript])
          } else {
            setSpeechEnded(true)
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
