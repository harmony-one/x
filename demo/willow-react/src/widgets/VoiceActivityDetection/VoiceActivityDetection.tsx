import {Box, Button} from "grommet";
import React, {useEffect, useRef} from "react";
import {observer} from "mobx-react";
import {watchMicAmplitude} from "./micAmplidute";
import {useStores} from "../../stores";

interface Props {
  mediaStream: MediaStream | null
}

export const VoiceActivityDetection = observer((props: Props) => {
  const { chatGpt } = useStores()

  const ref = useRef<HTMLDivElement>(null)

  const handleInterruptVoiceAi = () => {
    chatGpt.interruptVoiceAI()
  }

  useEffect(() => {
    if (!props.mediaStream) {
      return;
    }

    const stop = watchMicAmplitude({
      stream: props.mediaStream,
      threshold: 2,
      onDetect: (voiceDetected) => {
        if (voiceDetected) {
          handleInterruptVoiceAi()
        }
      },
      onUpdate: (val: number) => {
        if (ref.current) {
          ref.current.innerText = String(val.toFixed(1));
        }
      }
    })

    return () => {
      stop()
    }

  }, [props.mediaStream, ref])


  return (
    <Box direction="row" onClick={handleInterruptVoiceAi}>
      {/* <div>mic:</div><div ref={ref}></div> */}
    </Box>
  )
})