import React from 'react';
import { SpeechToTextWidget, OpenAIWidget } from "../widgets";
import { Box, Text } from "grommet";
import {AppModeButton} from "./AppModeButton";

interface Props {
  onReady: () => void
  onChangeOutput: (p: string) => void
}

export const DeveloperMode = ({onReady, onChangeOutput}: Props) => {
  return (
    <Box pad="32px" gap={'32px'} fill={true} style={{ height: '100vh' }}>
      <Box direction="column" justify="between" align="center" fill={true}>
        <Box width="800px">
          <Text>GPT4</Text>
          <OpenAIWidget />
        </Box>

        <Box width="800px" margin={{ bottom: '32px' }}>
          <Text>Speech-to-Text (Speechmatics)</Text>
          <SpeechToTextWidget onReady={onReady} onChangeOutput={onChangeOutput} />
        </Box>
        <Box>
          <AppModeButton />
        </Box>
      </Box>
    </Box>
  );
}
