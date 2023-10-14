import React from 'react';
import { SpeechToTextWidget, OpenAIWidget } from "../widgets";
import { Box, Text } from "grommet";
import { AppModeButton } from './buttons/AppModeButton';
import { MuteButton } from './buttons/MuteButton';

interface Props {
  onReady: () => void
  onChangeOutput: (p: string) => void
}

export const DeveloperMode = ({onReady, onChangeOutput}: Props) => {
  return (
    <Box pad="32px" gap={'32px'} fill={true} style={{ height: '100vh' }}>
      <Box direction="row" gap='6px'>
        <AppModeButton />
        <MuteButton />
      </Box>
      <Box direction="column" justify="between" align="center" fill={true}>
        <Box width="800px">
          <Text>GPT4</Text>
          <OpenAIWidget />
        </Box>
        <Box width="800px" margin={{ bottom: '32px' }}>
          <Text>Speech-to-Text (Deepgram Nova 2)</Text>
          <SpeechToTextWidget onReady={onReady} onChangeOutput={onChangeOutput} />
        </Box>
      </Box>
    </Box>
  );
}
