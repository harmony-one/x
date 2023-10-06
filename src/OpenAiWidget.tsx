import React, { useCallback, useEffect, useState } from 'react';
import OpenAI from 'openai';

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
        });

        for await (const part of stream) {
            resMessage += (part.choices[0]?.delta?.content || '');
            setMessage(resMessage);
        }
    }, []);

    useEffect(() => {
        if (props.input) {
            reqMessage(props.input);
        }
    }, [props.input])

    return <div>
        <div style={{ fontSize: '36px', color: '#DFDFDF' }}>
            Input: {props.input}
        </div>
        <div style={{
            marginTop: '16px',
            width: '400px',
            height: 'auto',
            border: '1px solid gray',
            borderRadius: '6px',
            padding: '8px',
            overflowY: 'scroll'
        }}>
            <div style={{ fontSize: '36px', color: '#12486B' }}>
                {message}
            </div>
        </div>
    </div>
}
