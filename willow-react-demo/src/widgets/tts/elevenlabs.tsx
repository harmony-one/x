import TTSPlugin from "./tts-plugin";
import { Voice } from "./types";
import { defaultElevenLabsVoiceID, defaultVoiceList } from "./elevenlabs-defaults";

function isProxySupported() {
    return false;
}

function shouldUseProxy(apiKey: string | undefined | null) {
    return !apiKey && isProxySupported();
}

function getEndpoint(proxied = false) {
    return proxied ? '/chatapi/proxies/elevenlabs' : 'https://api.elevenlabs.io';
}

function getVoiceFromElevenlabsVoiceObject(v: any) {
    return {
        service: "elevenlabs",
        id: v.voice_id,
        name: v.name,
        sampleAudioURL: v.preview_url,
    };
}

export interface ElevenLabsPluginOptions {
    apiKey: string | null;
    voice: string;
    customVoiceID: string | null;
}

/**
 * Plugin for integrating with ElevenLabs Text-to-Speech service.
 * 
 * If you want to add a plugin to support another cloud-based TTS service, this is a good example
 * to use as a reference.
 */
export default class ElevenLabsPlugin extends TTSPlugin<ElevenLabsPluginOptions> {
    static voices: Voice[] = defaultVoiceList.map(getVoiceFromElevenlabsVoiceObject);

    private proxied = shouldUseProxy(this.options?.apiKey);
    private endpoint = getEndpoint(this.proxied);

    /**
     * Initializes the plugin by fetching available voices.
     */
    async initialize() {
        await this.getVoices();
    }

    /**
     * Fetches and returns the available voices from ElevenLabs API.
     * This function stores the list of voices in a static variable, which is used elsewhere.
     * @returns {Promise<Voice[]>} A promise that resolves to an array of Voice objects.
     */
    async getVoices(): Promise<Voice[]> {
        const response = await fetch(`${this.endpoint}/v1/voices`, {
            headers: this.createHeaders(),
        });
        const json = await response.json();
        if (json?.voices?.length) {
            ElevenLabsPlugin.voices = json.voices.map(getVoiceFromElevenlabsVoiceObject);
        }
        return ElevenLabsPlugin.voices;
    }

    /**
     * Returns the current voice based on the plugin options.
     * @returns {Promise<Voice>} A promise that resolves to a Voice object.
     */
    async getCurrentVoice(): Promise<Voice> {
        let voiceID = this.options?.voice;

        // If using a custom voice ID, construct a voice object with the provided voice ID
        if (voiceID === 'custom' && this.options?.customVoiceID) {
            return {
                service: 'elevenlabs',
                id: this.options.customVoiceID,
                name: 'Custom Voice',
            };
        }

        // Search for a matching voice object
        const voice = ElevenLabsPlugin.voices.find(v => v.id === voiceID);
        if (voice) {
            return voice;
        }

        // If no matching voice is found, return a default Voice object
        // with the defaultElevenLabsVoiceID and 'elevenlabs' as the service
        return {
            service: 'elevenlabs',
            id: defaultElevenLabsVoiceID,
        };
    }

    /**
     * Converts the given text into speech using the specified voice and returns an audio file as a buffer.
     * @param {string} text The text to be converted to speech.
     * @param {Voice} [voice] The voice to be used for text-to-speech conversion. If not provided, the current voice will be used.
     * @returns {Promise<ArrayBuffer | null>} A promise that resolves to an ArrayBuffer containing the audio data, or null if the conversion fails.
     */
    async speakToBuffer(text: string, voice?: Voice): Promise<ArrayBuffer | null> {
        if (!voice) {
            voice = await this.getCurrentVoice();
        }

        const url = this.endpoint + '/v1/text-to-speech/' + voice.id;

        const response = await fetch(url, {
            headers: this.createHeaders(),
            method: 'POST',
            body: JSON.stringify({
                text,
            }),
        });

        if (response.ok) {
            return await response.arrayBuffer();
        } else {
            return null;
        }
    }

    /**
     * Creates and returns the headers required for ElevenLabs API requests.
     */
    private createHeaders(): Record<string, string> {
        const headers: Record<string, string> = {
            'Content-Type': 'application/json',
        }

        if (!this.proxied && this.options?.apiKey) {
            headers['xi-api-key'] = this.options.apiKey;
        }

        return headers;
    }
}