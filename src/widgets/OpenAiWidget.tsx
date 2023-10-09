import React, { useCallback, useEffect, useState } from 'react';
import OpenAI from 'openai';
import { ElevenlabsApi } from './ElevenlabsWidget/elevenlabs-ws-api';
import {Text, Box, TextArea} from 'grommet'

const openai = new OpenAI({
    apiKey: String(process.env.REACT_APP_SECRET_OPEN_AI),
    dangerouslyAllowBrowser: true
});

export interface IOpenAIWidget {
    input?: string;
    onChangeOutput: (output: string) => void;
}

export const OpenAIWidget = (props: IOpenAIWidget) => {
    const [message, setMessage] = useState('');

    const reqMessage = useCallback(async (content: string) => {
        let resMessage = ''

        const stream = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [{ role: 'user', content }],
            stream: true,
            max_tokens: 50,
            temperature: 0.8
        });

        // const elevenlabsApi = new ElevenlabsApi();
        //
        // await elevenlabsApi.startStream();

        for await (const part of stream) {
            const text = (part.choices[0]?.delta?.content || '');

            resMessage += text;
            setMessage(resMessage);

            // if (text) {
            //     await elevenlabsApi.sendChunkToStream(text);
            // }
        }

        // await elevenlabsApi.stopStream();
    }, []);

    useEffect(() => {
        props.onChangeOutput(message);
    }, [message]);

    useEffect(() => {
        if (props.input) {
            reqMessage(props.input);
        }
    }, [props.input])

    return <div>
        <div style={{
            marginTop: '16px',
            width: '400px',
            height: '300px',
            border: '1px solid gray',
            borderRadius: '6px',
            padding: '8px',
            overflowY: 'scroll'
        }}>
            <Text style={{ fontSize: '22px', color: '#12486B' }}>
                {message}
            </Text>
        </div>
    </div>
}
