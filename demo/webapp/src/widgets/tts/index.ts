import ExternalTTSAudioFilePlayer from "./audio-file-player";
import ElevenLabsPlugin from "./elevenlabs";
import {GoogleCloudPlugin} from "./googleCloudPlugin";
import config from "../../config";
import TTSPlugin from "./tts-plugin";

export enum TTSPlayerType {
  google = 'google',
  elevenlabs = 'elevenlabs'
}

export function getTTSPlayer(type: TTSPlayerType) {
  let plugin: TTSPlugin

  if(type === TTSPlayerType.elevenlabs) {
    plugin = new ElevenLabsPlugin({
      getOptions: () => ({
        apiKey: String(process.env.REACT_APP_SECRET_ELEVENLABS),
        voice: '21m00Tcm4TlvDq8ikWAM'
      })
    });
  } else {
    plugin = new GoogleCloudPlugin({
      getOptions: () => ({
        host: config.proxyHost,
      })
    })
  }

  return new ExternalTTSAudioFilePlayer(plugin);
}
