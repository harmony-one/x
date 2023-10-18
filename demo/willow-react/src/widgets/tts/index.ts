import ExternalTTSAudioFilePlayer from "./audio-file-player";
import WillowPlugin from "./willow";
import ElevenlabsPlugin from "./elevenlabs";

const ttsPluginWillow = new WillowPlugin({
    getOptions: () => ({
        apiKey: String(''),
        voice: '0'
    })
});

export const ttsPlayerWillow = new ExternalTTSAudioFilePlayer(ttsPluginWillow);

const ttsPluginElevenlabs = new ElevenlabsPlugin({
    getOptions: () => ({
        apiKey: String(process.env.REACT_APP_SECRET_ELEVENLABS),
        voice: '21m00Tcm4TlvDq8ikWAM'
    })
});

export const ttsPlayerElevenlabs = new ExternalTTSAudioFilePlayer(ttsPluginElevenlabs);

export enum PLAYERS {
    ElevenLabs = 'ElevenLabs',
    Willow = 'Willow',
}

export const players: Record<PLAYERS, ExternalTTSAudioFilePlayer> = {
    ElevenLabs: ttsPlayerElevenlabs,
    Willow: ttsPlayerWillow
}