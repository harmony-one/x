import React, { useState } from 'react';
import './App.css';
import { SpeechToTextWidget, OpenAIWidget } from "./widgets";

function App() {
  const [sttOutput, setSTTOutput] = useState<string | undefined>();
  const [gpt4Output, setGpt4Output] = useState<string | undefined>();

  return (
    <div className="App">
      <div>
        <h3>STT (Picovoice)</h3>
        <SpeechToTextWidget onChangeOutput={setSTTOutput} />
      </div>

      <div>
        <h3>{'==>'}</h3>
      </div>

      <div>
        <h3>GPT4</h3>
        <OpenAIWidget input={sttOutput} onChangeOutput={setGpt4Output} />
      </div>

      <div>
        <h3>{'==>'}</h3>
      </div>

      <div>
        <h3>TTS</h3>
        <div style={{ fontSize: '36px', color: '#DFDFDF' }}>
          In progress...
        </div>
      </div>
    </div>
  );
}

export default App;
