import React, { useEffect, useState } from 'react'
import { CheetahTranscript, Cheetah, CheetahModel } from '@picovoice/cheetah-web'
import { WebVoiceProcessor } from '@picovoice/web-voice-processor'
import {Box, Text, Spinner, TextArea} from "grommet";
import useDebounce from "../hooks/useDebounce";

// Get your key here: https://console.picovoice.ai/
const accessKey = String(process.env.REACT_APP_SECRET_PICOVOICE)

const modelParams: CheetahModel = {
  publicPath: 'cheetah_params.pv',
  customWritePath: "cheetah_model",
  forceWrite: false,
  version: 1,
}

export interface ISpeechToTextWidget {
  onReady: () => void
  onChangeOutput: (output: string) => void;
}

export const SpeechToTextWidget = (props: ISpeechToTextWidget) => {
  const [isInitialized, setInitialized] = useState(false)
  const [cheetahInstance, setCheetahInstance] = useState<Cheetah>()
  const [isCheetahRunning, setCheetahRunning] = useState(false)
  const [initInProgress, setInitInProgress] = useState(false)
  const [transcriptions, setTranscriptions] = useState<string[]>([])
  const [textValue, setTextValue] = useState('')

  const debouncedNotional = useDebounce(textValue, 500)

  const transcriptionCallback = (transcript: CheetahTranscript) => {
    // console.log('transcript', transcript)
    const text = transcript.transcript
    if (text) {
      setTranscriptions(
        transcriptions => transcriptions.some(text => text.includes('.')) ?
          [text] :
          [...transcriptions, text]
      )
    }
  }

  useEffect(() => {
    props.onChangeOutput(debouncedNotional)
  }, [debouncedNotional]);

  useEffect(() => {
    if (transcriptions.some(text => text.includes('.'))) {
      props.onChangeOutput(transcriptions.join(' '));
      // setTranscriptions([]);
    }
  }, [transcriptions])

  const processErrorCallback = (error: string) => {
    console.error('Error callback:', error)
  }

  const stopCheetah = async () => {
    try {
      setInitInProgress(true)
      if(cheetahInstance) {
        await WebVoiceProcessor.unsubscribe(cheetahInstance);
        setTranscriptions([])
        setCheetahRunning(false)
      }
    } catch (e) {
      console.error('Cannot unsubscribe Cheetah', e)
    } finally {
      setInitInProgress(false)
    }
  }

  const initCheetah = async () => {
    try {
      setInitInProgress(true)
      const cheetah = await Cheetah.create(
        accessKey,
        transcriptionCallback,
        modelParams,
        {
          enableAutomaticPunctuation: true,
          processErrorCallback
        }
      );
      setCheetahInstance(cheetah)
      await WebVoiceProcessor.subscribe(cheetah);
      setInitialized(true)
      setCheetahRunning(true)
      setTextValue('')
      props.onReady()
      console.log('Cheetah initialized')
    } catch (e) {
      console.error('Cannot init cheetah:', e)
    } finally {
      setInitInProgress(false)
    }
  }

  useEffect(() => {
    if (!isInitialized) {
      // initCheetah()
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
        {transcriptions[transcriptions.length - 1]}
      </div>
      <TextArea
        disabled={isCheetahRunning}
        value={textValue}
        onChange={(e) => {
          const text = e.target.value || ''
          setTextValue(text)
        }}
        style={{
          width: '100%',
          height: '100%',
          border: 'none',
          resize: 'none',
          outline: 'none',
          boxShadow: 'none'
      }}
      />
      {/*{[...transcriptions]*/}
      {/*  .reverse()*/}
      {/*  .filter((_, index) => index > 0)*/}
      {/*  .map((item, idx) => {*/}
      {/*    return <div key={String(idx)} style={{ color: 'gray' }}>{item}</div>*/}
      {/*  })*/}
      {/*}*/}
    </div>
    <Box align={'center'} direction={'row'} margin={{ top: '16px' }} gap={'8px'} justify={'start'}>
      {isCheetahRunning &&
          <Text onClick={stopCheetah}>Stop Speech-to-Text</Text>
      }
      {!isCheetahRunning &&
          <Text onClick={initCheetah}>Start Speech-to-Text</Text>
      }
      {initInProgress &&
        <Spinner size={'xsmall'} />
      }
    </Box>
  </Box>
}
