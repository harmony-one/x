import React, { useState } from 'react';
import './App.css';
import { SpeechToTextWidget, OpenAIWidget } from "./widgets";
import { Box, Text } from "grommet";

function App() {
  const [isInitialized, setInitialized] = useState(false)
  const [sttOutput, setSTTOutput] = useState<string | undefined>();
  const [gpt4Output, setGpt4Output] = useState<string | undefined>();

  const onReady = () => {
    setInitialized(true)
  }

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
          <OpenAIWidget input={sttOutput} onChangeOutput={setGpt4Output} />
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
