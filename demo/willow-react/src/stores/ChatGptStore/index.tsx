import { makeObservable, action, observable, computed } from "mobx";
import OpenAI from 'openai';
import { PLAYERS, players } from '../../widgets/tts';
import { isPhraseComplete } from "./helpers";
import ExternalTTSAudioFilePlayer from "../../widgets/tts/audio-file-player";

export enum AUTHOR {
  USER = 'user',
  GPT = 'gpt',
}

export interface IMessage {
  author: AUTHOR,
  text: string;
}

export class ChatGptStore {
  openai: OpenAI;
  ttsPlayerKey: PLAYERS;

  messages: IMessage[] = [];

  activeGptOutput: string = '';
  activeUserInput: string = '';

  isLoading: boolean = false;

  constructor() {
    makeObservable(this, {
      isLoading: observable,
      messages: observable,
      activeGptOutput: observable,
      activeUserInput: observable,
      ttsPlayerKey: observable,
      setPlayer: action,
      setUserInput: action,
      setGptOutput: action,
      loadGptAnswer: action,
      clearMessages: action,
      loadMessages: action
    })

    this.ttsPlayerKey = PLAYERS.ElevenLabs;

    this.openai = new OpenAI({
      apiKey: String(process.env.REACT_APP_SECRET_OPEN_AI),
      dangerouslyAllowBrowser: true
    });

    this.loadMessages();
  }

  setPlayer = (playerKey: PLAYERS) => {
    this.ttsPlayerKey = playerKey;
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

    try {
      const ttsPlayer: ExternalTTSAudioFilePlayer = players[this.ttsPlayerKey];

      const content = this.activeUserInput;
      let resMessage = ''

      ttsPlayer.clear();
      ttsPlayer.play();

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