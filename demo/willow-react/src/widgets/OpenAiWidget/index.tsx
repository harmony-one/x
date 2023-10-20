import React, { DOMElement, useEffect, useRef, useState } from 'react';
import { Text, Box, TextArea } from 'grommet'
import { observer } from 'mobx-react-lite';
import { useStores } from '../../stores';
import { AUTHOR } from '../../stores/ChatGptStore';
import { MessageBox } from './Components';

export const OpenAIWidget = observer(() => {
    const { chatGpt } = useStores();
    const containerEl = useRef(null);

    useEffect(() => {
        if (containerEl && (chatGpt.activeGptOutput || chatGpt.activeUserInput)) {
            //@ts-ignore
            const el: DOMElement = containerEl?.current;
            el.scrollTop = el.scrollHeight;
        }
    }, [containerEl, chatGpt.activeGptOutput, chatGpt.activeUserInput]);

    return <>
        {/* <Text onClick={() => chatGpt.clearMessages()}>Clear Chat</Text> */}
        <Box
            ref={containerEl}
            fill={true}
            direction="column"
            style={{
                border: '1px solid gray',
                borderRadius: '6px',
                overflowY: 'scroll',
                height: '500px'
            }}
            pad="24px"
        >
            <div>
                <Box direction="column" gap="20px">
                    {chatGpt.messages.map((message, idx) => {
                        return <MessageBox key={idx} message={message} />
                    })}
                    {
                        chatGpt.activeGptOutput &&
                        <MessageBox
                            message={{
                                author: AUTHOR.GPT,
                                text: `${chatGpt.activeGptOutput} ...`
                            }}
                        />
                    }
                </Box>
            </div>
        </Box>
        <Box
            margin="24px"
            pad="12px"
            align='center'
            style={{
                border: '1px solid #dedede',
                cursor: 'pointer',
                maxWidth: 200,
                borderRadius: 10,
            }}
            onClick={() => chatGpt.clearMessages()}
        >
            Clean chat
        </Box>
    </>
});