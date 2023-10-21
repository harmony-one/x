import React, { useEffect, useState } from 'react';
import './App.css';
import { useStores } from './stores';
import { observer } from "mobx-react";
import { Box, Button, Select, Text } from 'grommet';
import { OpenAIWidget } from './widgets';
import { PLAYERS } from './widgets/tts';
import { SpeechToTextWidget } from './widgets/SpeechToText';
import { Statistic } from './widgets/Statistic';
import { STT_CORES } from './stores/ChatGptStore';

//@ts-ignore
const client: any = new WillowClient({ host: `${process.env.REACT_APP_WILLOW_URL}/api/rtc/asr` })

client.on('onLog', () => {
})

client.on('onError', () => {
})

document.addEventListener("DOMContentLoaded", () => {
  try {
    client.init().catch(console.error)
  } catch (e) {
    console.error(e);
  }
})

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
    <Box
      align="start"
      pad="32px"
      gap={'32px'}
      fill={true}
      style={{ height: '100vh' }}
      direction='row'
      justify='center'
    >
      <Box
        gap="50px"
        justify="around"
        fill="vertical"
      >
        <Box
          direction='row'
          width="800px"
          justify="around"
          align="center"
        >
          <Box direction='column' gap="10px">
            <Text>Select STT core:</Text>
            <Select
              options={Object.keys(STT_CORES)}
              style={{
                maxWidth: 200
              }}
              value={chatGpt.sttKey}
              onChange={({ option }) => chatGpt.setSttKey(option)}
            />
          </Box>

          <Box>
            <Text>Gpt4</Text>
          </Box>

          <Box direction='column' gap="10px">
            <Text>Select TTS core:</Text>
            <Select
              options={Object.keys(PLAYERS)}
              style={{
                maxWidth: 200
              }}
              value={chatGpt.ttsPlayerKey}
              onChange={({ option }) => chatGpt.setPlayer(option)}
            />
          </Box>
        </Box>

        <Box direction="column" justify="between" align="center" fill={true}>
          <Box width="800px">
            <OpenAIWidget />
          </Box>

          <Box direction='column' gap="20px">
            {lastResult && <Box>
              {/* <Text>
              Text: {lastResult.text}
            </Text>

            <Text>
              Req Time: <span style={{ color: 'green' }}>{lastResult.time} ms</span>
            </Text> */}

              {/* <Text>
                {chatGpt.sttTime} ms + {chatGpt.llmTime} ms + {chatGpt.ttsTime} ms = {
                  chatGpt.sttTime + chatGpt.llmTime + chatGpt.ttsTime
                } ms
              </Text> */}
            </Box>}

            {
              chatGpt.sttKey === STT_CORES.Willow ?
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
                </Button> :
                <SpeechToTextWidget
                  onChangeOutput={text => {
                    chatGpt.setUserInput(text);
                    chatGpt.loadGptAnswer();
                  }}
                  onReady={() => { }}
                />
            }
          </Box>
        </Box>
      </Box>

      <Box basis='0'>
        <Statistic />
      </Box>
    </Box>
  );
})

export default App;
