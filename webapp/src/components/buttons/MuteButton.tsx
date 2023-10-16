import React from 'react';
import {Box, Button, Text} from "grommet";
import {useStores} from "../../stores";
import {observer} from "mobx-react";

export const MuteButton = observer(() => {
  const {app} = useStores()

  const handleSwitchMode = () => {
      app.toggleMute()
      return;
  }

  return (<Button onClick={handleSwitchMode} color={app.muted ? "red" : "green"} style={{ borderRadius: '50%', width: '10px', height: '10px', padding: '0' }}/> )
})
