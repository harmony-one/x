import React, { useCallback, useEffect, useState } from 'react';
import { ElevenlabsApi } from './elevenlabs-ws-api';

export interface IElevenlabsWidget {
    input?: string;
    onChangeOutput: (output: string) => void;
}

export const ElevenlabsWidget = (props: IElevenlabsWidget) => {
    const reqMessage = useCallback(async (content: string) => {
        const api = new ElevenlabsApi();

        api.textToSpeach(content);
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
    </div>
}
