import React, { useEffect, useState } from 'react';
import './App.css';
import { useStores } from './stores';
import { MainScreen } from "./components/MainScreen";
import { observer } from "mobx-react";

const App = observer(() => {
  const { chatGpt } = useStores();
  const [isInitialized, setInitialized] = useState(false)
  const [sttOutput, setSTTOutput] = useState<string | undefined>();

  const onReady = () => {
    setInitialized(true)
  }

  useEffect(() => {
    if (sttOutput) {
      chatGpt.setUserInput(sttOutput);
      chatGpt.loadGptAnswer();
    }
  }, [sttOutput]);

  return (
    <MainScreen onReady={onReady} onChangeOutput={setSTTOutput} />
  );
})

export default App;
