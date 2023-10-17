import ExternalTTSAudioFilePlayer from "./audio-file-player";
import ElevenLabsPlugin from "./elevenlabs";
import {GoogleCloudPlugin} from "./googleCloudPlugin";
import config from "../../config";
import TTSPlugin from "./tts-plugin";

let ttsPlugin: TTSPlugin = new ElevenLabsPlugin({
  getOptions: () => ({
    apiKey: String(process.env.REACT_APP_SECRET_ELEVENLABS),
    voice: '21m00Tcm4TlvDq8ikWAM'
  })
});

if (config.tts.plugin === 'google') {
  ttsPlugin = new GoogleCloudPlugin({
    getOptions: () => ({
      projectId: config.gc.projectId,
      token: config.gc.token
    })
  })
}

export const ttsPlayer = new ExternalTTSAudioFilePlayer(ttsPlugin);

export function createPlayerTTS() {
    return new ExternalTTSAudioFilePlayer(ttsPlugin);
}
