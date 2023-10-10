import EventEmitter from "events";
import { split } from "sentence-splitter";

export interface TTSPlayerState {
    playing: boolean;
    ended: boolean;
    buffering: boolean;
    duration?: number;
    index: number;
    length: number;
    ready?: number;
    downloadable: boolean;
}

export abstract class AbstractTTSPlayer extends EventEmitter {
    private lines: string[] = [];
    private streamText: string = '';
    protected sentences: string[] = [];
    protected complete = false;

    abstract play(index?: number): Promise<any>;
    abstract pause(): Promise<any>;
    abstract getState(): TTSPlayerState;
    abstract destroy(): any;

    timerId: NodeJS.Timeout | undefined;

    public setText(lines: string[], complete: boolean) {
        console.log(111, lines);
        this.lines = lines;
        this.complete = complete;
        this.updateSentences();
    }

    public startStream() {
        this.clearLines();
        this.complete = false;
        this.updateSentences();
    }

    public addStreamText(text: string) {
        this.streamText += text;

        if (this.streamText.length > 10) {
            this.lines.push(this.streamText);
            this.streamText = '';
            this.updateSentences();
        }
    }

    public endStream() {
        this.lines.push(this.streamText);
        this.complete = true;
        this.updateSentences();
        this.clearLines();
    }

    clearLines = () => {
        this.lines = [];
        this.streamText = '';
    }

    private updateSentences() {
        const output: string[] = [];
        for (const line of this.lines) {
            const sentences = split(line);
            for (const sentence of sentences) {
                output.push(sentence.raw.trim());
            }
        }
        this.sentences = output.filter(s => s.length > 0);
    }
}

export interface Voice {
    service: string;
    id: string;
    name?: string;
    sampleAudioURL?: string;
}