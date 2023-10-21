import ExternalTTSAudioFilePlayer from "./audio-file-player";
import WillowPlugin from "./willow";
import ElevenlabsPlugin from "./elevenlabs";
import { ProxyPlugin } from "./proxyPlugin";

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

const ttsPluginGoogleCloud = new ProxyPlugin({
    getOptions: () => ({
        proxyApi: 'https://x-proxy.fly.dev/text-to-speech/google',
    })
})

export const ttsPlayerGoogle = new ExternalTTSAudioFilePlayer(ttsPluginGoogleCloud);

const ttsPluginAzure = new ProxyPlugin({
    getOptions: () => ({
        proxyApi: 'https://x-proxy.fly.dev/text-to-speech/azure',
    })
})

export const ttsPlayerAzure = new ExternalTTSAudioFilePlayer(ttsPluginAzure);

export enum PLAYERS {
    ElevenLabs = 'ElevenLabs',
    Willow = 'Willow',
    Google = 'Google',
    Azure = 'Azure',
}

export const players: Record<PLAYERS, ExternalTTSAudioFilePlayer> = {
    ElevenLabs: ttsPlayerElevenlabs,
    Willow: ttsPlayerWillow,
    Google: ttsPlayerGoogle,
    Azure: ttsPlayerAzure
}