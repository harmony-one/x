import React, { useState } from 'react';
import { Text, Box, TextArea } from 'grommet'
import { observer } from 'mobx-react-lite';
import { useStores } from '../stores';

export const OpenAIWidget = observer(() => {
    const { chatGpt } = useStores();

    return <Box fill={true}>
        <Text style={{ fontSize: '20px', color: '#DFDFDF' }}>
            {chatGpt.activeUserInput}
        </Text>
        <Box
            fill={true}
            style={{
                border: '1px solid gray',
                borderRadius: '6px',
                overflowY: 'scroll',
                height: '500px'
            }}
        >
            <Text style={{ fontSize: '20px', color: '#12486B' }}>
                {chatGpt.activeGptOutput}
            </Text>
        </Box>
    </Box>
});
