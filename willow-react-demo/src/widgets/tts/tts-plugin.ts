import { Voice } from "./types";

export interface PluginContext {
    getOptions(): any;
}

export default class TTSPlugin<T = any> {
    constructor(public context?: PluginContext) {
    }

    get options(): T | undefined {
        return this.context?.getOptions();
    }

    async getVoices(): Promise<Voice[]> {
        return [];
    }

    async getCurrentVoice(): Promise<Voice> {
        throw new Error("not implemented");
    }

    async speakToBuffer(text: string, voice?: Voice): Promise<ArrayBuffer | null | undefined> {
        throw new Error("not implemented");
    }
}