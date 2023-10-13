import React, { useEffect, useState } from 'react';
import './App.css';
import { useStores } from './stores';
import {observer} from "mobx-react";
import { Box, Text } from 'grommet';
import { OpenAIWidget } from './widgets';
import { WillowClient } from '@tovera/willow-ts-client'

const client = new WillowClient({ host: "http://localhost:19000/api/rtc/asr" })

client.on('onOpen', () => {
  console.log('Connection open. Recording for 30 seconds.')
  client.start()
  setTimeout(()=>client.stop(), 30*1000)
})
client.on('onLog', (log) => {
  console.log('Verbose server log: ' + log)
})
client.on('onError', (err) => {
  console.error('Willow WebRTC Error', err)
})
client.on('onInfer', (msg) => {
  console.log(`Got result ${msg.text} in ${msg.time}ms`)
})

await client.init();

const App = observer(() => {
  const { chatGpt, app } = useStores();
  const [sttOutput, setSTTOutput] = useState<string | undefined>();

  useEffect(() => {
    if (sttOutput) {
      chatGpt.setUserInput(sttOutput);
      chatGpt.loadGptAnswer();
    }
  }, [sttOutput]);

  return (
    <Box pad="32px" gap={'32px'} fill={true} style={{ height: '100vh' }}>
      <Box direction="column" justify="between" align="center" fill={true}>
        <Box width="800px">
          <Text>GPT4</Text>
          <OpenAIWidget />
        </Box>
      </Box>
    </Box>
  );
})

export default App;
