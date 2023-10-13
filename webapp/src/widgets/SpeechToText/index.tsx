import React, {CSSProperties, useEffect, useMemo, useState} from 'react'
import {Box, Button, Text} from "grommet";
import {getJwt} from "./utils/auth";
import {
  AudioRecorder,
  useAudioDenied,
  useAudioDevices,
  useRequestDevices,
} from './utils/recorder';
import {RealtimeSession, RealtimeRecognitionResult, AddTranscript} from 'speechmatics';
import MicSelect from "./MicSelect";
import useDebounce from "../../hooks/useDebounce";

// Get your key here: https://console.picovoice.ai/
const SpeechmaticsApiKey = String(process.env.REACT_APP_SPEECHMATICS_API_KEY)
const DeepgramApiKey = String(process.env.REACT_APP_DEEPGRAM_API_KEY)

type SessionState = 'configure' | 'starting' | 'blocked' | 'error' | 'running';

export interface ISpeechToTextWidget {
  onReady: () => void
  onChangeOutput: (output: string) => void;
}

type TranscriptionButtonProps = {
  startTranscription: () => void;
  stopTranscription: () => void;
  sessionState: SessionState;
};

// function SquareIcon(props: React.SVGProps<SVGSVGElement> & CSSProperties) {
//   return (
//     <span style={{ ...props.style }}>
//       <svg
//         width={6}
//         height={6}
//         fill='none'
//         xmlns='http://www.w3.org/2000/svg'
//         {...props}
//       >
//         <title>A Square Icon</title>
//         <path fill='#fff' d='M0 0h6v6H0z' />
//       </svg>
//     </span>
//   );
// }

// function CircleIcon(props: React.SVGProps<SVGSVGElement> & CSSProperties) {
//   return (
//     <span style={{ ...props.style }}>
//       <svg
//         width='1em'
//         height='1em'
//         viewBox='0 0 12 12'
//         fill='none'
//         xmlns='http://www.w3.org/2000/svg'
//         {...props}
//       >
//         <title>A Circle Icon</title>
//         <circle cx={6} cy={6} r={4} fill='#C84031' />
//         <path
//           fillRule='evenodd'
//           clipRule='evenodd'
//           d='M6 12A6 6 0 106 0a6 6 0 000 12zm0-.857A5.143 5.143 0 106 .857a5.143 5.143 0 000 10.286z'
//           fill='#C84031'
//         />
//       </svg>
//     </span>
//   );
// }


// function TranscriptionButton({
//                                startTranscription,
//                                stopTranscription,
//                                sessionState,
//                              }: TranscriptionButtonProps) {
//   return (
//     <Box margin={{ top: '16px' }} width={'300px'}>
//       {['configure', 'stopped', 'starting', 'error', 'blocked'].includes(
//         sessionState,
//       ) && (
//         <Button onClick={startTranscription} label={
//           <Box direction={'row'} justify={'center'} align={'center'} gap={'8px'}>
//             <CircleIcon />
//             Start Transcribing
//           </Box>
//         }
//         />
//       )}

//       {sessionState === 'running' &&
//         (<Button onClick={stopTranscription} label={
//           <Box direction={'row'} justify={'center'} align={'center'} gap={'8px'}>
//             <SquareIcon />
//             Stop Transcribing
//           </Box>
//         }
//         />)}
//     </Box>
//   );
// }

export const SpeechToTextWidget = (props: ISpeechToTextWidget) => {
  const [isInitialized, setInitialized] = useState(false)

  const [rtSession, setRealTimeSession] = useState<RealtimeSession>()
  const [transcriptions, setTranscriptions] = useState<
    RealtimeRecognitionResult[]
  >([]);
  const [transcriptionText, setTranscriptionText] = useState('')
  const [audioDeviceIdState, setAudioDeviceId] = useState<string>('');
  const [sessionState, setSessionState] = useState<SessionState>('configure');

  // const debouncedText = useDebounce(transcriptionText, 2000)

  // const onSendToGPT = () => {
  //   console.log('Send to GPT4:', transcriptionText)
  //   props.onChangeOutput(transcriptionText)
  //   setTranscriptions([])
  //   setTranscriptionText('')
  // }

  // const onClearText = () => {
  //   console.log('Clear text')
  //   setTranscriptions([])
  //   setTranscriptionText('')
  // }

  useEffect(() => {
    navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
      const mediaRecorder = new MediaRecorder(stream, { mimeType: 'audio/webm' })
      const socket = new WebSocket('wss://api.deepgram.com/v1/listen', [ 'token', DeepgramApiKey ])
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

        // console.log('transcript: ', transcript)
        // console.log('transcriptionText: ', transcriptionText)
        if(transcript !== transcriptionText) {
          setTranscriptionText(transcript)
          props.onChangeOutput(transcript)
        }
      }
    })
  }, []);

  // Get devices using our custom hook
  const devices = useAudioDevices();
  const denied = useAudioDenied();
  const requestDevices = useRequestDevices();

  const audioDeviceIdComputed =
    devices.length &&
    !devices.some((item) => item.deviceId === audioDeviceIdState)
      ? devices[0].deviceId
      : audioDeviceIdState;

  // sendAudio is used as a wrapper for the websocket to check the socket is finished init-ing before sending data
  const sendAudio = async (audioBlob: Blob) => {
    // console.log('sendAudio', audioBlob)
    // const audiofile = new File([audioBlob], "audiofile.webm", { type: "audio/webm" })
    //
    // const formData = new FormData();
    //
    // formData.append("file", audiofile);
    //
    // const result = await axios.post(
    //   `http://localhost:3005/decodeAudio`,
    //   formData,
    // )
    // console.log('Send audio start', rtSession && rtSession.rtSocketHandler)
    // if (rtSession && rtSession.rtSocketHandler && rtSession.isConnected()) {
    //   rtSession.sendAudio(data);
    // }
  };

  // Memoise AudioRecorder so it doesn't get recreated on re-render
  const audioRecorder = useMemo(() => new AudioRecorder(sendAudio), [rtSession]);

  // const startTranscription = async () => {
  //   setSessionState('starting');
  //   try {
  //     await audioRecorder.startRecording(audioDeviceIdComputed);
  //     setTranscriptions([]);
  //     setTranscriptionText('')
  //   } catch (err) {
  //     setSessionState('blocked');
  //     return;
  //   }
  //   try {
  //     if(rtSession) {
  //       await rtSession.start({
  //         transcription_config: {
  //           language: 'en',
  //           operating_point: 'enhanced',
  //           max_delay: 2,
  //           enable_partials: false
  //         },
  //         audio_format: {
  //           type: 'file',
  //         },
  //       });
  //     }
  //   } catch (err) {
  //     setSessionState('error');
  //   }
  // };

  // Stop the transcription on click to end the recording
  // const stopTranscription = async () => {
  //   await audioRecorder.stopRecording();
  //   if(rtSession) {
  //     await rtSession.stop();
  //   }
  // };

  // const initSTT = async () => {
  //   try {
  //     const jwtToken = await getJwt(SpeechmaticsApiKey)
  //     console.log('JWT:', jwtToken)
  //     const session = new RealtimeSession(jwtToken)
  //     setRealTimeSession(session)

  //     // Attach our event listeners to the realtime session
  //     session.addListener('AddTranscript', (res: AddTranscript) => {
  //       const { results } = res
  //       if(results.length === 0) {
  //         setTranscriptions([]);
  //       } else {
  //         setTranscriptions(transcriptions =>
  //           [...transcriptions, ...results]
  //         );
  //       }
  //     });

  //     // start audio recording once the websocket is connected
  //     session.addListener('RecognitionStarted', async () => {
  //       setSessionState('running');
  //     });

  //     session.addListener('EndOfTranscript', async () => {
  //       setSessionState('configure');
  //       await audioRecorder.stopRecording();
  //     });

  //     session.addListener('Error', async () => {
  //       setSessionState('error');
  //       await audioRecorder.stopRecording();
  //     });

  //     props.onReady()
  //     console.log('Initialized')
  //     setInitialized(true)
  //   } catch (e) {
  //     console.error('Cannot init STT:', e)
  //   }
  // }

  // useEffect(() => {
  //   if (!isInitialized) {
  //     initSTT()
  //   }
  // }, [isInitialized]);

  useEffect(() => {
    if(transcriptions.length) {
      const text = transcriptions.map(
        (item, index) => {
          const { alternatives = [] } = item
          return (index && !['.', ','].includes(alternatives[0]?.content)
            ? ' '
            : '') + item?.alternatives?.[0]?.content
        }).join(' ')

      if(text.length > 1) {
        setTranscriptionText(text)
      }
    }
  }, [transcriptions]);

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
      {/*<Box height={'100%'} gap={'16px'}>*/}
      {/*  <Button primary label="Send to GPT4" onClick={onSendToGPT} />*/}
      {/*  <Button label="Clear text" onClick={onClearText} />*/}
      {/*</Box>*/}
    </Box>
    {/*<Box>*/}
    {/*  <Box margin={{ top: '32px' }}>*/}
    {/*    {(sessionState === 'blocked' || denied) && (*/}
    {/*      <p className='warning-text'>Microphone permission is blocked</p>*/}
    {/*    )}*/}
    {/*  </Box>*/}
    {/*  <MicSelect*/}
    {/*    disabled={!['configure', 'blocked'].includes(sessionState)}*/}
    {/*    onClick={requestDevices}*/}
    {/*    value={audioDeviceIdComputed}*/}
    {/*    options={devices.map((item) => {*/}
    {/*      return { value: item.deviceId, label: item.label };*/}
    {/*    })}*/}
    {/*    onChange={(e) => {*/}
    {/*      if (sessionState === 'configure') {*/}
    {/*        setAudioDeviceId(e.target.value);*/}
    {/*      } else if (sessionState === 'blocked') {*/}
    {/*        setSessionState('configure');*/}
    {/*        setAudioDeviceId(e.target.value);*/}
    {/*      } else {*/}
    {/*        console.warn('Unexpected mic change during state:', sessionState);*/}
    {/*      }*/}
    {/*    }}*/}
    {/*  />*/}
    {/*  <Box direction={'row'} gap={'32px'} align={'center'} justify={'between'}>*/}
    {/*    <TranscriptionButton*/}
    {/*      sessionState={sessionState}*/}
    {/*      stopTranscription={stopTranscription}*/}
    {/*      startTranscription={startTranscription}*/}
    {/*    />*/}
    {/*    <Box pad={{ top: '8px' }}>*/}
    {/*      {sessionState === 'error' && (*/}
    {/*        <Box className='warning-text'>Session encountered an error</Box>*/}
    {/*      )}*/}
    {/*      {['starting', 'running', 'configure', 'blocked'].includes(*/}
    {/*        sessionState,*/}
    {/*      ) && <Box><Text color={'gray'}>State: {sessionState}</Text></Box>}*/}
    {/*    </Box>*/}
    {/*  </Box>*/}
    {/*</Box>*/}
  </Box>
}
