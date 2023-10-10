import React, { useState } from 'react';
import './App.css';
import { SpeechToTextWidget, OpenAIWidget } from "./widgets";
import {Box, Text} from "grommet";

function App() {
  const [isInitialized, setInitialized] = useState(false)
  const [sttOutput, setSTTOutput] = useState<string | undefined>();
  const [gpt4Output, setGpt4Output] = useState<string | undefined>();

  const onReady = () => {
    setInitialized(true)
  }

  return (
    <div className="App" >
      <Box margin={{ top: '32px' }} gap={'32px'}>
        <Box>
          <Text>
            {isInitialized ? 'App ready. Say something.' : 'Waiting for model initialization...'}
          </Text>
        </Box>
        <Box direction={'row'} gap={'128px'} align={'center'}>
          <Box>
            <Text>Speech-to-Text (Picovoice)</Text>
            <SpeechToTextWidget onReady={onReady} onChangeOutput={setSTTOutput} />
          </Box>
          <Box>
            <Text size={'32px'}>→</Text>
          </Box>
          <Box>
            <Text>GPT4</Text>
            <OpenAIWidget input={sttOutput} onChangeOutput={setGpt4Output} />
          </Box>
      </Box>
      </Box>

      {/* <div>
        <h3>{'==>'}</h3>
      </div>

      <div>
        <h3>TTS (Elevenlabs)</h3>
        <ElevenlabsWidget input={gpt4Output} onChangeOutput={() => { }} />
      </div> */}
    </div>
  );
}

export default App;
