import ExternalTTSAudioFilePlayer from "./audio-file-player";
import WillowPlugin from "./willow";

const ttsPlugin = new WillowPlugin({
    getOptions: () => ({
        apiKey: String(''),
        voice: '0'
    })
});

export const ttsPlayer = new ExternalTTSAudioFilePlayer(ttsPlugin);

