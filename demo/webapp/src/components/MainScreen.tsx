import React from 'react';
import { observer } from "mobx-react";
import { SpeechToTextWidget, OpenAIWidget } from "../widgets";
import { Box, Text } from "grommet";
import { useStores } from "../stores";
import styled from 'styled-components'
import { AppModeButton } from "./AppModeButton";
import { AppMode } from "../stores/AppStore";

interface Props {
  onReady: () => void
  onChangeOutput: (p: string) => void
}

const ScreenContainer = styled(Box)<{ appMode: AppMode }>`
  height: 100vh;
  background-color: ${(props) => (props.appMode === 'production' ? '#010101' : '#ffffff')};
`

export const MainScreen = observer(({onReady, onChangeOutput}: Props) => {
  const { app } = useStores();

  return (
    <ScreenContainer appMode={app.appMode} pad="32px" gap={'32px'} fill={true} style={{ height: '100vh' }} >
      <Box>
        <AppModeButton />
      </Box>
      <Box direction="column" justify="between" align="center" fill={true} style={{visibility: app.appMode === 'developer' ? 'visible' : 'hidden' }}>
        <Box width="800px">
          <Text>GPT4</Text>
          <OpenAIWidget />
        </Box>
        <Box width="800px" margin={{ bottom: '16px' }}>
          <SpeechToTextWidget
            onReady={onReady}
            onChangeOutput={onChangeOutput}
          />
        </Box>
      </Box>
    </ScreenContainer>
  );
})
