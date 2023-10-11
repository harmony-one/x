import React from 'react';
import { Text, Box } from 'grommet'
import { AUTHOR, IMessage } from '../../stores/ChatGptStore';

export const MessageBox = ({ message }: { message: IMessage }) => {
    return <Box
        direction="row"
        justify={
            message.author === AUTHOR.GPT ? "start" : 'end'
        }
    >
        <div
            style={{
                padding: '8px',
                border: '1px solid rgb(222, 222, 222)',
                borderRadius: '10px',
                width: 'auto',
                height: 'auto',
                backgroundColor: message.author === AUTHOR.GPT ? "rgba(0, 0, 0, 0.05)" : 'rgb(231, 248, 255)',
            }}
        >
            <Text style={{ fontSize: '20px', color: 'rgb(36, 41, 47)' }}>
                {message.text}
            </Text>
        </div>
    </Box>
}