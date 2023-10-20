import { makeObservable, action, observable, computed } from "mobx";
import OpenAI from 'openai';
import { PLAYERS, players } from '../../widgets/tts';
import { isPhraseComplete } from "./helpers";
import ExternalTTSAudioFilePlayer from "../../widgets/tts/audio-file-player";

export enum AUTHOR {
  USER = 'user',
  GPT = 'gpt',
}

export enum STT_CORES {
  Willow = 'Willow',
  'Deepgram Nova 2' = 'Deepgram Nova 2',
}

export interface IReqTime {
  stt: number;
  llm: number;
  tts: number;
  sttCore: string;
  ttsCore: string;
}

export interface IMessage {
  author: AUTHOR,
  text: string;
}

export class ChatGptStore {
  openai: OpenAI;
  ttsPlayerKey: PLAYERS;
  sttKey: STT_CORES;

  messages: IMessage[] = [];

  activeGptOutput: string = '';
  activeUserInput: string = '';

  isLoading: boolean = false;

  ttsTime: number = 0;
  llmTime: number = 0;
  sttTime: number = 0;

  reqTimes: IReqTime[] = [];

  constructor() {
    makeObservable(this, {
      isLoading: observable,
      messages: observable,
      activeGptOutput: observable,
      activeUserInput: observable,
      ttsPlayerKey: observable,
      reqTimes: observable,
      sttKey: observable,

      addReqTime: action,
      setPlayer: action,
      setUserInput: action,
      setGptOutput: action,
      loadGptAnswer: action,
      clearMessages: action,
      loadMessages: action,

      setTTSTime: action,
      setLLMTime: action,
      setSTTTime: action,

      ttsTime: observable,
      llmTime: observable,
      sttTime: observable,
    })

    this.ttsPlayerKey = PLAYERS.ElevenLabs;
    this.sttKey = STT_CORES["Deepgram Nova 2"];

    this.openai = new OpenAI({
      apiKey: String(process.env.REACT_APP_SECRET_OPEN_AI),
      dangerouslyAllowBrowser: true
    });

    this.loadMessages();
  }

  setTTSTime = (time: number) => this.ttsTime = time;
  setLLMTime = (time: number) => this.llmTime = time;
  setSTTTime = (time: number) => this.sttTime = time;

  setPlayer = (playerKey: PLAYERS) => {
    this.ttsPlayerKey = playerKey;
  }

  setSttKey = (sttKey: STT_CORES) => {
    this.sttKey = sttKey;
  }

  addReqTime = (props: IReqTime) => this.reqTimes.push(props);

  interruptVoiceAI() {
    const ttsPlayer: ExternalTTSAudioFilePlayer = players[this.ttsPlayerKey];

    // ttsPlayer.clear()
    // ttsPlayer.destroy()
    console.log('Interrupt TTS')
  }

  setUserInput = (text: string) => {
    this.activeUserInput = text;

    this.messages.push({
      author: AUTHOR.USER,
      text
    })
  }

  setGptOutput = (text: string) => {
    this.activeGptOutput = text;
  }

  loadGptAnswer = async () => {
    this.isLoading = true;

    this.setLLMTime(0);
    this.setTTSTime(0);

    try {
      const ttsPlayer: ExternalTTSAudioFilePlayer = players[this.ttsPlayerKey];

      const content = this.activeUserInput;
      let resMessage = ''

      ttsPlayer.clear();
      ttsPlayer.play();

      const startTime = Date.now();

      const stream = await this.openai.chat.completions.create({
        model: 'gpt-4',
        messages: [{ role: 'user', content }],
        stream: true,
        max_tokens: 100,
        temperature: 0.8
      });

      const lines: string[] = [];
      let currentLineIdx = 0;
      let text = '';

      for await (const part of stream) {
        if (!currentLineIdx) {
          this.setLLMTime(Date.now() - startTime);
        }

        text = (part.choices[0]?.delta?.content || '');

        resMessage += text;
        this.setGptOutput(resMessage);
        lines[currentLineIdx] = (lines[currentLineIdx] ?? '') + text;

        if (isPhraseComplete(lines[currentLineIdx], !currentLineIdx)) {
          ttsPlayer.setText(lines, false);
          currentLineIdx++;
        }
      }

      lines.push(text);

      ttsPlayer.setText(lines, true);

      this.messages.push({
        author: AUTHOR.GPT,
        text: this.activeGptOutput
      })

      setTimeout(() =>
      this.addReqTime({
        stt: this.sttTime,
        llm: this.llmTime,
        tts: this.ttsTime,
        ttsCore: this.ttsPlayerKey[0],
        sttCore: this.sttKey[0],
      }), 2000);

      this.saveMessages();
    } catch (e) {
      console.error('loadGptAnswer', e);
    }

    this.activeGptOutput = '';
    this.activeUserInput = '';
    this.isLoading = false;
  }

  saveMessages = () => {
    localStorage.setItem('gpt_messages', JSON.stringify(this.messages.map(m => m)));
  }

  loadMessages = () => {
    const localStorageMessString = localStorage.getItem('gpt_messages');

    if (localStorageMessString) {
      this.messages.push(...JSON.parse(localStorageMessString));
    }
  }

  clearMessages = () => {
    this.messages = [];
    this.saveMessages();
  }
}