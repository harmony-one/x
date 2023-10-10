import React, {CSSProperties, useEffect, useMemo, useRef, useState} from 'react'
import {Box, Text, Spinner, TextArea} from "grommet";
import {getJwt} from "./utils/auth";
import {
  AudioRecorder,
  useAudioDenied,
  useAudioDevices,
  useRequestDevices,
} from './utils/recorder';
import { RealtimeSession, RealtimeRecognitionResult } from 'speechmatics';
import MicSelect from "./MicSelect";

// Get your key here: https://console.picovoice.ai/
const SpeechmaticsApiKey = String(process.env.REACT_APP_SPEECHMATICS_API_KEY)

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

function SquareIcon(props: React.SVGProps<SVGSVGElement> & CSSProperties) {
  return (
    <span style={{ ...props.style }}>
      <svg
        width={6}
        height={6}
        fill='none'
        xmlns='http://www.w3.org/2000/svg'
        {...props}
      >
        <title>A Square Icon</title>
        <path fill='#fff' d='M0 0h6v6H0z' />
      </svg>
    </span>
  );
}

function CircleIcon(props: React.SVGProps<SVGSVGElement> & CSSProperties) {
  return (
    <span style={{ ...props.style }}>
      <svg
        width='1em'
        height='1em'
        viewBox='0 0 12 12'
        fill='none'
        xmlns='http://www.w3.org/2000/svg'
        {...props}
      >
        <title>A Circle Icon</title>
        <circle cx={6} cy={6} r={4} fill='#C84031' />
        <path
          fillRule='evenodd'
          clipRule='evenodd'
          d='M6 12A6 6 0 106 0a6 6 0 000 12zm0-.857A5.143 5.143 0 106 .857a5.143 5.143 0 000 10.286z'
          fill='#C84031'
        />
      </svg>
    </span>
  );
}


function TranscriptionButton({
                               startTranscription,
                               stopTranscription,
                               sessionState,
                             }: TranscriptionButtonProps) {
  return (
    <div className='bottom-button-status'>
      {['configure', 'stopped', 'starting', 'error', 'blocked'].includes(
        sessionState,
      ) && (
        <button
          type='button'
          className='bottom-button start-button'
          disabled={sessionState === 'starting'}
          onClick={async () => {
            startTranscription();
          }}
        >
          <CircleIcon style={{ marginRight: '0.25em', marginTop: '1px' }} />
          Start Transcribing
        </button>
      )}

      {sessionState === 'running' && (
        <button
          type='button'
          className='bottom-button stop-button'
          onClick={() => stopTranscription()}
        >
          <SquareIcon style={{ marginRight: '0.25em', marginBottom: '1px' }} />
          Stop Transcribing
        </button>
      )}
    </div>
  );
}

export const SpeechToTextWidget = (props: ISpeechToTextWidget) => {
  const [isInitialized, setInitialized] = useState(false)

  const [rtSession, setRealTimeSession] = useState<RealtimeSession>()
  const [transcription, setTranscription] = useState<
    RealtimeRecognitionResult[]
  >([]);
  const [transcriptionText, setTranscriptionText] = useState('')
  const [audioDeviceIdState, setAudioDeviceId] = useState<string>('');
  const [sessionState, setSessionState] = useState<SessionState>('configure');

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
  const sendAudio = (data: Blob) => {
    // console.log('Send audio start', rtSession && rtSession.rtSocketHandler)
    if (rtSession && rtSession.rtSocketHandler && rtSession.isConnected()) {
      rtSession.sendAudio(data);
    }
  };

  // Memoise AudioRecorder so it doesn't get recreated on re-render
  const audioRecorder = useMemo(() => new AudioRecorder(sendAudio), [rtSession]);

  // Call the start method on click to start the websocket
  const startTranscription = async () => {
    setSessionState('starting');
    try {
      await audioRecorder.startRecording(audioDeviceIdComputed);
      setTranscription([]);
      setTranscriptionText('')
    } catch (err) {
      setSessionState('blocked');
      return;
    }
    try {
      if(rtSession) {
        await rtSession.start({
          transcription_config: { max_delay: 2, language: 'en' },
          audio_format: {
            type: 'file',
          },
        });
      }
    } catch (err) {
      setSessionState('error');
    }
  };

  // Stop the transcription on click to end the recording
  const stopTranscription = async () => {
    await audioRecorder.stopRecording();
    if(rtSession) {
      await rtSession.stop();
    }
  };

  const initSTT = async () => {
    try {
      const jwtToken = await getJwt(SpeechmaticsApiKey)
      console.log('JWT:', jwtToken)
      const session = new RealtimeSession(jwtToken)
      setRealTimeSession(session)

      // Attach our event listeners to the realtime session
      session.addListener('AddTranscript', (res: any) => {
        const newTranscription = [...transcription, ...res.results]

        const text = newTranscription.map(
          (item, index) => {
            const { alternatives = [] } = item
            return (index && !['.', ','].includes(alternatives[0]?.content)
              ? ' '
              : '') + item?.alternatives?.[0]?.content
          }).join(' ')

        setTranscription(newTranscription);
        setTranscriptionText(text)
      });

      // start audio recording once the websocket is connected
      session.addListener('RecognitionStarted', async () => {
        setSessionState('running');
      });

      session.addListener('EndOfTranscript', async () => {
        setSessionState('configure');
        await audioRecorder.stopRecording();
      });

      session.addListener('Error', async () => {
        setSessionState('error');
        await audioRecorder.stopRecording();
      });

      props.onReady()
      console.log('Initialized')
      setInitialized(true)
    } catch (e) {
      console.error('Cannot init STT:', e)
    } finally {

    }
  }

  console.log('transcription', transcription)

  useEffect(() => {
    if (!isInitialized) {
      initSTT()
    }
  }, [isInitialized]);

  return <Box>
    <div style={{
      marginTop: '16px',
      width: '400px',
      height: '300px',
      border: '1px solid gray',
      borderRadius: '6px',
      padding: '8px',
      overflowY: 'scroll'
    }}>
      <div style={{ fontSize: '36px', color: '#12486B' }}>
        {transcriptionText}
      </div>
    </div>
    <Box>
      <div className='flex-row'>
        <p>Select Microphone</p>
        {(sessionState === 'blocked' || denied) && (
          <p className='warning-text'>Microphone permission is blocked</p>
        )}
      </div>
      <MicSelect
        disabled={!['configure', 'blocked'].includes(sessionState)}
        onClick={requestDevices}
        value={audioDeviceIdComputed}
        options={devices.map((item) => {
          return { value: item.deviceId, label: item.label };
        })}
        onChange={(e) => {
          if (sessionState === 'configure') {
            setAudioDeviceId(e.target.value);
          } else if (sessionState === 'blocked') {
            setSessionState('configure');
            setAudioDeviceId(e.target.value);
          } else {
            console.warn('Unexpected mic change during state:', sessionState);
          }
        }}
      />
      <TranscriptionButton
        sessionState={sessionState}
        stopTranscription={stopTranscription}
        startTranscription={startTranscription}
      />
      {sessionState === 'error' && (
        <p className='warning-text'>Session encountered an error</p>
      )}
      {['starting', 'running', 'configure', 'blocked'].includes(
        sessionState,
      ) && <p>State: {sessionState}</p>}
    </Box>
  </Box>
}
