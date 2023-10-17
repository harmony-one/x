import React, { useEffect, useState } from 'react';
import './App.css';
import { useStores } from './stores';
import {DeveloperMode} from "./components/DeveloperMode";
import { ProductionMode } from './components/ProductionMode';
import {observer} from "mobx-react";

const App = observer(() => {
  const { chatGpt, app } = useStores();
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
    <>
      {app.appMode === 'developer' ? (<DeveloperMode onReady={onReady} onChangeOutput={setSTTOutput} />) : null }
      {app.appMode === 'production' ? (<ProductionMode onReady={onReady} onChangeOutput={setSTTOutput} />) : null }
    </>
  );
})

export default App;
