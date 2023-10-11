import React, { useCallback, useEffect, useState } from 'react';
import OpenAI from 'openai';
import { Text, Box, TextArea } from 'grommet'
import { ttsPlayer } from './tts';
import { observer } from 'mobx-react-lite';
import { useStores } from '../stores';

const isPhraseComplete = (text: string, isFirst = false) => {
    const wordsAmount = text.split(' ').length;

    const specSymbols = ['?', '.', '!'];

    if (isFirst) {
        return wordsAmount > 7 || [...specSymbols, ','].some(symbol => text.includes(symbol));
    } else {
        return wordsAmount > 14 || specSymbols.some(symbol => text.includes(symbol));
    }
}

const openai = new OpenAI({
    apiKey: String(process.env.REACT_APP_SECRET_OPEN_AI),
    dangerouslyAllowBrowser: true
});

export interface IOpenAIWidget {
    input?: string;
    onChangeOutput: (output: string) => void;
}

export const OpenAIWidget = observer((props: IOpenAIWidget) => {
    const { chatGpt } = useStores();
    const [message, setMessage] = useState('');

    const reqMessage = useCallback(async (content: string) => {
        let resMessage = ''

        ttsPlayer.clear();
        ttsPlayer.play();

        const stream = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [{ role: 'user', content }],
            stream: true,
            max_tokens: 100,
            temperature: 0.8
        });

        const lines: string[] = [];
        let currentLineIdx = 0;
        let text = '';

        for await (const part of stream) {
            text = (part.choices[0]?.delta?.content || '');

            resMessage += text;
            setMessage(resMessage);
            lines[currentLineIdx] = (lines[currentLineIdx] ?? '') + text;

            if (isPhraseComplete(lines[currentLineIdx], !currentLineIdx)) {
                ttsPlayer.setText(lines, false);
                currentLineIdx++;
            }
        }

        lines.push(text);

        ttsPlayer.setText(lines, true);
    }, []);

    useEffect(() => {
        props.onChangeOutput(message);
    }, [message]);

    useEffect(() => {
        if (props.input) {
            reqMessage(props.input);
        }
    }, [props.input])

    return <Box fill={true}>
        <Text style={{ fontSize: '20px', color: '#DFDFDF' }}>
            {props.input}
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
                {message}
            </Text>
        </Box>
    </Box>
});
