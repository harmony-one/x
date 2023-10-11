import React, { useEffect, useState } from 'react';
import './App.css';
import { SpeechToTextWidget, OpenAIWidget } from "./widgets";
import { Box, Text } from "grommet";
import { useStores } from './stores';

function App() {
  const { chatGpt } = useStores();
  const [isInitialized, setInitialized] = useState(false)
  const [sttOutput, setSTTOutput] = useState<string | undefined>();

  const onReady = () => {
    setInitialized(true)
  }

  useEffect(() => {
    if (sttOutput) {
      chatGpt.setUserInput(sttOutput);
      chatGpt.loadGptAnswer();
    }
  }, [sttOutput]);

  return (
    <Box pad="32px" gap={'32px'} fill={true} style={{ height: '100vh' }}>
      {/* <Box>
        <Text>
          {isInitialized ? 'App ready. Say something.' : 'Waiting for model initialization...'}
        </Text>
      </Box> */}
      <Box direction="column" justify="between" align="center" fill={true}>
        <Box width="800px">
          <Text>GPT4</Text>
          <OpenAIWidget />
        </Box>

        <Box basis="250px" width="800px">
          <Text>Speech-to-Text (Speechmatics)</Text>
          <SpeechToTextWidget onReady={onReady} onChangeOutput={setSTTOutput} />
        </Box>
      </Box>
    </Box>
  );
}

export default App;
