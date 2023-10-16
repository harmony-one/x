import React, { useEffect, useState } from 'react';
import './App.css';
import { useStores } from './stores';
import { observer } from "mobx-react";
import { Box, Text, TextInput } from 'grommet';
import { OpenAIWidget } from './widgets';
import { ttsPlayer } from './widgets/tts';

const App = observer(() => {
  const { chatGpt, app } = useStores();
  const [sttOutput, setSTTOutput] = useState<string | undefined>();

  // const init = async () => {
  //   ttsPlayer.clear();
  //   ttsPlayer.play();

  //   ttsPlayer.setText(['Hello - how are you?'], true);
  // }

  return (
    <Box pad="32px" gap={'32px'} fill={true} style={{ height: '100vh' }}>
      <Box direction="column" justify="between" align="center" fill={true}>
        <Box width="800px">
          <Text>GPT4</Text>
          <OpenAIWidget />
        </Box>

        <Box direction='column' gap="20px">
          <TextInput
            value={sttOutput}
            onChange={e => setSTTOutput(e.target.value)}
          />

          <Box onClick={() => {
            if (sttOutput) {
              chatGpt.setUserInput(sttOutput);
              chatGpt.loadGptAnswer();
            }
          }}>
            Send text to GPT
          </Box>
        </Box>
      </Box>
    </Box>
  );
})

export default App;
