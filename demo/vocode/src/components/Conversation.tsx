import { Box, Button, HStack, VStack, Select, Spinner } from "@chakra-ui/react";
import React, {useEffect} from "react";
import { useConversation, AudioDeviceConfig, ConversationConfig } from "vocode";
import MicrophoneIcon from "./MicrophoneIcon";
import AudioVisualization from "./AudioVisualization";
import { isMobile } from "react-device-detect";
import {SelfHostedConversationConfig} from "vocode/src/types/conversation";

const Conversation = ({
  config,
}: {
  config: Omit<ConversationConfig, "audioDeviceConfig"> | Omit<SelfHostedConversationConfig, 'audioDeviceConfig'>;
}) => {
  const [audioDeviceConfig, setAudioDeviceConfig] =
    React.useState<AudioDeviceConfig>({});
  const [inputDevices, setInputDevices] = React.useState<MediaDeviceInfo[]>([]);
  const [outputDevices, setOutputDevices] = React.useState<MediaDeviceInfo[]>(
    []
  );
  let transcripts: any[] = [];
  // "transcriberConfig",
  // "agentConfig",
  // "synthesizerConfig",
  // "vocodeConfig",
  // @ts-ignore
  delete config.transcriberConfig;
  const { status, start, stop, analyserNode, transcripts: transcriptsA, active } = useConversation(
    Object.assign(config, { audioDeviceConfig })
  );

  const [started, setStarted] = React.useState(false)

  React.useEffect(() => {
    console.log('### updated status', status);
  }, [status]);

  React.useEffect(() => {
    console.log('### updated active', active);
  }, [active]);

  React.useEffect(() => {
    console.log('### updated transcripts', transcriptsA);
  }, [transcriptsA]);

  // React.useEffect(() => {
  //   console.log('### updated start');
  // }, [start])

  React.useEffect(() => {
    console.log('### updated analyserNode');
  }, [analyserNode])

  React.useEffect(() => {
    if (status === 'idle' && analyserNode && !started) {
      console.log('### start conversation');
      setStarted(true)
      start()
    }
  }, [status, start, started, analyserNode]);
  // const { status, start, stop, analyserNode, transcripts } = useConversation({
  //   backendUrl: "wss://56686e955e8c.ngrok.app/conversation",
  //   subscribeTranscript: false,
  //   audioDeviceConfig,
  // });

  React.useEffect(() => {
    navigator.mediaDevices
      .enumerateDevices()
      .then((devices) => {
        setInputDevices(
          devices.filter(
            (device) => device.deviceId && device.kind === "audioinput"
          )
        );
        setOutputDevices(
          devices.filter(
            (device) => device.deviceId && device.kind === "audiooutput"
          )
        );
      })
      .catch((err) => {
        console.error(err);
      });
  });

  const [showSettings, setShowSettings] = React.useState(false);
  const [showUI, setShowUI] = React.useState(false);

  return (
    <>
      {analyserNode && <AudioVisualization analyser={analyserNode} />}
      {showUI && <Button
        variant="link"
        disabled={["connecting", "error"].includes(status)}
        onClick={status === "connected" ? stop : start}
        position={"absolute"}
        top={"45%"}
        left={"50%"}
        transform={"translate(-50%, -50%)"}
      >
        <Box boxSize={75}>
          <MicrophoneIcon color={"#ddfafa"} muted={status !== "connected"} />
        </Box>
      </Button>}
      <Box boxSize={50} />
      {showUI && status === "connecting" && (
        <Box
          position={"absolute"}
          top="57.5%"
          left="50%"
          transform={"translate(-50%, -50%)"}
          padding={5}
        >
          <Spinner color="#FFFFFF" />
        </Box>
      )}
      {!isMobile && showSettings && (
        <HStack width="96%" position="absolute" top={"10%"} left="2%">
          {inputDevices.length > 0 && (
            <Select
              color={"#FFFFFF"}
              disabled={["connecting", "connected"].includes(status)}
              onChange={(event) =>
                setAudioDeviceConfig({
                  ...audioDeviceConfig,
                  inputDeviceId: event.target.value,
                })
              }
              value={audioDeviceConfig.inputDeviceId}
            >
              {inputDevices.map((device, i) => {
                return (
                  <option key={i} value={device.deviceId}>
                    {device.label}
                  </option>
                );
              })}
            </Select>
          )}
          {outputDevices.length > 0 && (
            <Select
              color={"#FFFFFF"}
              disabled
              onChange={(event) =>
                setAudioDeviceConfig({
                  ...audioDeviceConfig,
                  outputDeviceId: event.target.value,
                })
              }
              value={audioDeviceConfig.outputDeviceId}
            >
              {outputDevices.map((device, i) => {
                return (
                  <option key={i} value={device.deviceId}>
                    {device.label}
                  </option>
                );
              })}
            </Select>
          )}
          <Select
            color={"#FFFFFF"}
            disabled={["connecting", "connected"].includes(status)}
            onChange={(event) =>
              event.target.value &&
              setAudioDeviceConfig({
                ...audioDeviceConfig,
                outputSamplingRate: parseInt(event.target.value),
              })
            }
            placeholder="Set output sampling rate"
            value={audioDeviceConfig.outputSamplingRate}
          >
            {["8000", "16000", "24000", "44100", "48000"].map((rate, i) => {
              return (
                <option key={i} value={rate}>
                  {rate} Hz
                </option>
              );
            })}
          </Select>
        </HStack>
      )}
      { transcripts.length > 0 && (
        <VStack width="35%" position="absolute" top={"50%"} height={"45%"} left="2%" alignItems="left" overflowY="auto">
          {
            transcripts.map((item, index) => {
              return <Box key={"t" + index.toString()} color="white">{item.sender}: {item.text}</Box>
            })
          }
        </VStack>
      )}
    </>
  );
};

export default Conversation;
