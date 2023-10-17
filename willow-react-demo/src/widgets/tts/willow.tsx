import TTSPlugin from "./tts-plugin";
import { Voice } from "./types";
import QueryString from "qs";

function isProxySupported() {
    return false;
}

function shouldUseProxy(apiKey: string | undefined | null) {
    return !apiKey && isProxySupported();
}

function getEndpoint(proxied = true) {
    return proxied ? 'http://localhost:8000' : process.env.REACT_APP_WILLOW_URL;
}

export interface WillowPluginOptions {
    apiKey: string | null;
    voice: string;
    customVoiceID: string | null;
}

/**
 * Plugin for integrating with Willow Text-to-Speech service.
 * 
 * If you want to add a plugin to support another cloud-based TTS service, this is a good example
 * to use as a reference.
 */
export default class WillowPlugin extends TTSPlugin<WillowPluginOptions> {
    static voices: Voice[] = [];

    private proxied = shouldUseProxy(this.options?.apiKey);
    private endpoint = getEndpoint(this.proxied);

    /**
     * Initializes the plugin by fetching available voices.
     */
    async initialize() {
        // await this.getVoices();
    }

    /**
     * Fetches and returns the available voices from Willow API.
     * This function stores the list of voices in a static variable, which is used elsewhere.
     * @returns {Promise<Voice[]>} A promise that resolves to an array of Voice objects.
     */
    async getVoices(): Promise<Voice[]> {
        const response = await fetch(`${this.endpoint}/v1/voices`, {
            headers: this.createHeaders(),
        });
        const json = await response.json();
        if (json?.voices?.length) {
            WillowPlugin.voices = [];
        }
        return WillowPlugin.voices;
    }

    /**
     * Returns the current voice based on the plugin options.
     * @returns {Promise<Voice>} A promise that resolves to a Voice object.
     */
    async getCurrentVoice(): Promise<Voice> {
        let voiceID = this.options?.voice;

        if (!WillowPlugin.voices.length) {
            return {
                service: 'willow',
                id: '0',
                name: 'Custom Voice',
            };
        }

        // Search for a matching voice object
        const voice = WillowPlugin.voices.find(v => v.id === voiceID);
        if (voice) {
            return voice;
        }

        // If no matching voice is found, return a default Voice object
        // with the defaultWillowVoiceID and 'Willow' as the service
        return {
            service: 'Willow',
            id: '0',
        };
    }

    /**
     * Converts the given text into speech using the specified voice and returns an audio file as a buffer.
     * @param {string} text The text to be converted to speech.
     * @param {Voice} [voice] The voice to be used for text-to-speech conversion. If not provided, the current voice will be used.
     * @returns {Promise<ArrayBuffer | null>} A promise that resolves to an ArrayBuffer containing the audio data, or null if the conversion fails.
     */
    async speakToBuffer(text: string, voice?: Voice): Promise<ArrayBuffer | null> {
        const queryString = QueryString.stringify({
            text,
            format: 'FLAC',
            speaker: 'CLB'
        })

        return fetch(`${this.endpoint}/api/tts?${queryString}`, {
            "headers": {
                "accept": "application/json",
                "sec-fetch-dest": "empty",
                "sec-fetch-mode": "cors",
                "sec-fetch-site": "same-origin"
            },
            "referrerPolicy": "strict-origin-when-cross-origin",
            "body": null,
            "method": "GET",
            "mode": "cors",
            "credentials": "omit"
        }).then(res => res.arrayBuffer())
    }

    /**
     * Creates and returns the headers required for Willow API requests.
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