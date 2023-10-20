import React, { useEffect, useState } from 'react';
import { useStores } from '../../stores';
import { observer } from "mobx-react";
import { Box, Button, Select, Text } from 'grommet';

const TextCell = (props: any) => <Box
    pad="12px"
    style={{
        minWidth: 70,
        maxWidth: 70,
        border: '1px solid #dedede'
    }}
>
    <Text>
        {props.children}
    </Text>
</Box>

export const Statistic = observer(() => {
    const { chatGpt, app } = useStores();

    return (
        <Box
            direction="column"
            style={{
                // border: '1px solid gray',
                // borderRadius: '6px',
                overflowY: 'scroll',
                maxHeight: '800px',
                minWidth: 350
            }}
        >
            <div>
                <Box style={{ minWidth: 320 }}>
                    <Box direction="row">
                        <TextCell>STT (ms)</TextCell>
                        <TextCell>LLM (ms)</TextCell>
                        <TextCell>TTS (ms)</TextCell>
                        <TextCell>Total (ms)</TextCell>
                        <TextCell>AI</TextCell>
                    </Box>
                    {chatGpt.reqTimes.map((req, idx) => {
                        return <Box
                            key={idx}
                            direction="row"
                        >
                            <TextCell>{req.stt}</TextCell>
                            <TextCell>{req.llm}</TextCell>
                            <TextCell>{req.tts}</TextCell>
                            <TextCell>{req.stt + req.llm + req.tts}</TextCell>
                            <TextCell>{req.sttCore}+{req.ttsCore}</TextCell>
                        </Box>
                    })}
                </Box>
            </div>
        </Box>
    );
})
