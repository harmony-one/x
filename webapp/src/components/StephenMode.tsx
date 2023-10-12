import React from 'react';
import { SpeechToTextWidget } from "../widgets";
import { Box } from "grommet";
import {AppModeButton} from "./AppModeButton";

interface Props {
  onReady: () => void
  onChangeOutput: (p: string) => void
}

export const StephenMode = ({onReady, onChangeOutput}: Props) => {
  return (
    <Box pad="32px" gap={'32px'} fill={true} align="center" style={{ height: '100vh', backgroundColor: '#010101' }}>
      <SpeechToTextWidget onReady={onReady} onChangeOutput={onChangeOutput} />
      <Box>
        <AppModeButton />
      </Box>
    </Box>
  );
}
