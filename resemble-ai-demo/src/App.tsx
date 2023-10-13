import React, { useEffect, useState } from 'react';
import './App.css';
import { observer } from "mobx-react";
import { Box, Button, Text, TextArea, TextInput } from 'grommet';

import { Resemble } from '@resemble/node';

Resemble.setApiKey(String(process.env.REACT_APP_RESEMBLE_API_KEY));

const createProject = async () => {
  const res = await Resemble.v2.projects.create({
    name: "Test",
    description: "x tests",
    is_public: false,
    is_collaborative: true,
    is_archived: false
  })

  console.log(res);
}

// createProject();

const textToSpeach = async (text: string, voiceUuid: string) => {
  const projectUuid = '4a7baea9';
  // const voiceUuid = 'd3e61caf';

  const response = await Resemble.v2.clips.createSync(projectUuid, {
    body: text,
    voice_uuid: voiceUuid,
    is_public: false,
    is_archived: false,
    sample_rate: 16000,
    output_format: 'mp3'
  })

  //@ts-ignore
  return response.item.audio_src;
}

const App = observer(() => {
  const [audioLinks, setAudioLinks] = useState<Array<{ link: string, time: number }>>([]);
  const [text, setText] = useState('');
  const [error, setError] = useState('');
  const [voice, setVoice] = useState('d3e61caf');
  const [isLoading, setIsLoading] = useState(false);

  const addAudioLink = (link: string, time: number) => {
    setAudioLinks(audioLinks => [...audioLinks, { link, time }])
  }

  return (
    <Box pad="32px" gap={'32px'} fill={true} style={{ height: '100vh' }}>
      <Box direction="column" justify="between" align="center" fill={true}>
        <Box width="800px">
          <h2>Resemble AI text to speach playground</h2>

          <Box margin={{ vertical: '12px' }}>
            <Text>Voice:</Text>
            <TextInput
              style={{
                maxWidth: 200
              }}
              disabled={isLoading}
              value={voice}
              onChange={o => setVoice(o.target.value)}
            />
          </Box>

          <Text>Text:</Text>
          <TextArea
            disabled={isLoading}
            value={text}
            onChange={o => setText(o.target.value)}
          />

          <Box
            margin="24px"
            pad="12px"
            style={{
              border: '1px solid #DFDFDF',
              maxWidth: 200,
              borderRadius: 8,
              opacity: isLoading ? 0.5 : 1
            }}
            onClick={async () => {
              if (text && !isLoading) {
                setIsLoading(true);
                setError('');
                try {
                  const startDate = Date.now();
                  const link = await textToSpeach(text, voice);
                  addAudioLink(link, Date.now() - startDate);
                } catch (e) {
                  //@ts-ignore
                  setError(e.message)
                }
                setIsLoading(false);
              }
            }}>
            {isLoading ? 'Loading...' : 'Create clip'}
          </Box>

          {
            error && <Box margin={{ vertical: '12px' }}>
              <Text color="red">{error}</Text>
            </Box>
          }

          <Box gap='10px'>
            {audioLinks.map(({ link, time }) =>
              <Box direction='row' align='center' key={link} gap="10px">
                <audio controls autoPlay>
                  <source src={link} type="audio/mpeg" />
                </audio>
                <Text>Generation time: {time / 1000} sec</Text>
              </Box>
            )
            }
          </Box>
        </Box>
      </Box>
    </Box>
  );
})

export default App;
