import React, { DOMElement, useEffect, useRef, useState } from 'react';
import {Text, Box, TextArea, Select} from 'grommet'
import { observer } from 'mobx-react-lite';
import { useStores } from '../../stores';
import { AUTHOR } from '../../stores/ChatGptStore';
import { MessageBox } from './Components';
import {SpeechModel, SpeechModelAlias} from "../SpeechToText/types";
import {getTTSPlayer, TTSPlayerType} from "../tts";
import {useNavigate, useSearchParams} from "react-router-dom";

export const OpenAIWidget = observer(() => {
    const navigate = useNavigate()
    const [searchParams] = useSearchParams()
    const ttsModel = (searchParams.get('ttsModel') || TTSPlayerType.google) as TTSPlayerType

    const { chatGpt } = useStores();
    const containerEl = useRef(null);

    useEffect(() => {
        if (containerEl && (chatGpt.activeGptOutput || chatGpt.conversationContext)) {
            //@ts-ignore
            const el: DOMElement = containerEl?.current;
            el.scrollTop = el.scrollHeight;
        }
    }, [containerEl, chatGpt.activeGptOutput, chatGpt.conversationContext]);

    const ttsOptions = Object.values(TTSPlayerType).map(value => {
        return {
            value,
            alias: value
        }
    })

    useEffect(() => {
        chatGpt.setTTSPlayer(ttsModel)
    }, [ttsModel]);

    const onTTSModelChange = (type: TTSPlayerType) => {
        const sttModel = searchParams.get('sttModel')
        let path = `/?ttsModel=${type}`
        if(sttModel) {
            path = `${path}&sttModel=${sttModel}`
        }
        navigate(path)
    }

    return <>
        {/* <Text onClick={() => chatGpt.clearMessages()}>Clear Chat</Text> */}
        <Box direction={'row'} align={'baseline'} gap={'16px'}>
            <Box>
                <Text>GPT4 + </Text>
            </Box>
            <Box width={'260px'}>
                <Select
                  size={'small'}
                  value={ttsOptions.find(option => option.value === chatGpt.ttsPlayerType)}
                  options={ttsOptions}
                  labelKey={'alias'}
                  onChange={({ option }) => onTTSModelChange(option.value)}
                />
            </Box>
        </Box>
        <Box
            margin={{ top: '16px' }}
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
                                text: `${chatGpt.activeGptOutput} ...`,
                                inGptContext: false
                            }}
                        />
                    }
                </Box>
            </div>
        </Box>
    </>
});
