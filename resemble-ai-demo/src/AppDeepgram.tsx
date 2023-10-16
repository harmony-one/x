import React, { useEffect, useRef, useState } from 'react';
import './App.css';
import { observer } from "mobx-react";
import { Box, Button, Select, Text, TextArea, TextInput } from 'grommet';
import { SpeechToTextWidget } from './widgets/SpeechToText';

interface ITranscription {
  transcript: string;
  startMs: number;
  durationMs: number;
  endMs: number;
}

const AppDeepgram = observer(() => {
  const [audioLinks, setAudioLinks] = useState<Array<{ link: string, time: number }>>([]);

  const [transcriptions, setTranscriptions] = useState<ITranscription[]>([]);

  const containerEl = useRef(null);

  useEffect(() => {
      if (containerEl && (transcriptions.length)) {
          //@ts-ignore
          const el: DOMElement = containerEl?.current;
          el.scrollTop = el.scrollHeight;
      }
  }, [containerEl, transcriptions]);

  console.log(transcriptions);

  return (
    <Box pad="32px" gap={'32px'} fill={true} style={{ overflow: 'scroll' }}>
      <Box direction="column" justify="between" align="center" fill={true}>
        <Box width="800px">
          <h2>Deepgram AI speach to text</h2>

          <h3>Please speak into the microphone:</h3>

          <SpeechToTextWidget
            onGetTranscriptions={
              t => setTranscriptions(transcriptions => [...transcriptions, t])
            }
          />

          <Box
            ref={containerEl}
            fill={true}
            pad="24px"
            style={{
              maxHeight: 600,
              overflow: 'scroll',
              border: '1px solid #DEDEDE'
            }}
          >
            <div>
              <Box gap='10px'>
                {transcriptions.map((ts, idx) =>
                  <Box direction='row' align='center' key={idx} gap="10px">
                    <Text>{ts.transcript}</Text>
                    <Text color="#8e8484">(Duration: {ts.durationMs / 1000} sec)</Text>
                  </Box>
                )
                }
              </Box>
            </div>
          </Box>
        </Box>
      </Box>
    </Box>
  );
})

export default AppDeepgram;
