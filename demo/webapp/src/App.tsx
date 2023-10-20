import React, { useEffect, useState } from 'react';
import './App.css';
import { useStores } from './stores';
import { MainScreen } from "./components/MainScreen";
import { observer } from "mobx-react";
import {Route, Routes} from "react-router-dom";

const App = observer(() => {
  const { chatGpt } = useStores();
  const [isInitialized, setInitialized] = useState(false)

  const onReady = () => {
    setInitialized(true)
  }

  const onChangeOutput = (text: string) => {
    if(text) {
      chatGpt.interruptOpenAiStream()
      chatGpt.setUserInput(text);
      chatGpt.loadGptAnswer();
    }
  }

  return (
    <Routes>
      <Route path={'/'} element={<MainScreen onReady={onReady} onChangeOutput={onChangeOutput} />}>
      </Route>
    </Routes>
  );
})

export default App;
