import React from 'react';
import {Box, Button, Text} from "grommet";
import {useStores} from "../../stores";
import {observer} from "mobx-react";

export const AppModeButton = observer(() => {
  const {app} = useStores()

  const handleSwitchMode = () => {
    if (app.appMode === 'stephen') {
      app.changeMode('developer')
      return;
    }

    if (app.appMode === 'developer') {
      app.changeMode('stephen')
      return;
    }
  }

  return (<Button onClick={handleSwitchMode} color ="blue" style={{ borderRadius: '50%', width: '10px', height: '10px', padding: '0' }}/> )
})
