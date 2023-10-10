import ExternalTTSAudioFilePlayer from "./audio-file-player";
import ElevenLabsPlugin from "./elevenlabs";

const ttsPlugin = new ElevenLabsPlugin({
    getOptions: () => ({
        apiKey: String(process.env.REACT_APP_SECRET_ELVENLABS),
        voice: '21m00Tcm4TlvDq8ikWAM'
    })
});

export const ttsPlayer = new ExternalTTSAudioFilePlayer(ttsPlugin);

