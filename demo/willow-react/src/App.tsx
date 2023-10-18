import React, { useEffect, useState } from 'react';
import './App.css';
import { useStores } from './stores';
import { observer } from "mobx-react";
import { Box, Button, Select, Text } from 'grommet';
import { OpenAIWidget } from './widgets';
import { PLAYERS } from './widgets/tts';

//@ts-ignore
const client: any = new WillowClient({ host: `${process.env.REACT_APP_WILLOW_URL}/api/rtc/asr` })

client.on('onLog', () => {
})

client.on('onError', () => {
})

client.init();

const App = observer(() => {
  const [isInitialized, setInitialized] = useState(false);
  const [recording, setRecording] = useState(false);
  const { chatGpt, app } = useStores();
  const [lastResult, setLastResult] = useState<any>();

  useEffect(() => {
    client.on('onOpen', () => {
      setInitialized(true);
    })

    client.on('onInfer', (msg: any) => {
      setLastResult(msg);
      console.log(msg);

      chatGpt.setSTTTime(msg.time);

      chatGpt.setUserInput(msg.text);
      chatGpt.loadGptAnswer();
    })
  }, [])

  return (
    <Box pad="32px" gap={'32px'} fill={true} style={{ height: '100vh' }}>
      <Box direction="column" justify="between" align="center" fill={true}>
        <Box width="800px">
          <Text>GPT4</Text>
          <OpenAIWidget />
        </Box>

        <Box direction='column' gap="20px">
          <Text>Select TTS core</Text>
          <Select
            options={Object.keys(PLAYERS)}
            style={{
              maxWidth: 200
            }}
            value={chatGpt.ttsPlayerKey}
            onChange={({ option }) => chatGpt.setPlayer(option)}
          />
        </Box>

        <Box direction='column' gap="20px">
          {lastResult && <Box>
            {/* <Text>
              Text: {lastResult.text}
            </Text>

            <Text>
              Req Time: <span style={{ color: 'green' }}>{lastResult.time} ms</span>
            </Text> */}

            <Text>
              {chatGpt.sttTime} ms + {chatGpt.llmTime} ms + {chatGpt.ttsTime} ms = {
                chatGpt.sttTime + chatGpt.llmTime + chatGpt.ttsTime
              } ms
            </Text>
          </Box>}

          <Button
            disabled={!isInitialized}
            onClick={() => {
              if (recording) {
                setRecording(false);
                client.stop();
              } else {
                setRecording(true);
                client.start();
              }
            }}
            style={{
              background: '#0d6efd',
              padding: 20,
              borderRadius: 10
            }}
            alignSelf='center'
          >
            <Text color='white'>
              {!recording ? 'Start Recording' : 'Stop Recording'}
            </Text>
          </Button>
        </Box>
      </Box>
    </Box>
  );
})

export default App;
