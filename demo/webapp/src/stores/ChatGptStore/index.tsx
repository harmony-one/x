import { makeObservable, action, observable, computed } from "mobx";
import OpenAI from 'openai';
import { createPlayerTTS } from '../../widgets/tts';
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

  messages: IMessage[] = [];

  activeGptOutput: string = '';

  isLoading: boolean = false;
  conversationContextLength = 20
  ttsPlayer: ExternalTTSAudioFilePlayer | null = null;

  constructor() {
    makeObservable(this, {
      ttsPlayer: observable,
      isLoading: observable,
      messages: observable,
      activeGptOutput: observable,
      setUserInput: action,
      setGptOutput: action,
      loadGptAnswer: action,
      clearMessages: action,
      loadMessages: action,
      activeUserInput: computed
    })

    this.openai = new OpenAI({
      apiKey: String(process.env.REACT_APP_SECRET_OPEN_AI),
      dangerouslyAllowBrowser: true
    });

    this.loadMessages();
  }

  get activeUserInput () {
    const messagesList = [...this.messages]
      .reverse()
      .filter((_, index) => index < this.conversationContextLength)
      .reverse()
      .reduce((acc, nextItem) => {
        acc += ` ${nextItem.text}`
        return acc
      }, '')
    return messagesList
    // return this.messages[this.messages.length - 1].text || ''
  }

  setUserInput = (text: string) => {
    this.messages.push({
      author: AUTHOR.USER,
      text
    })
  }

  setGptOutput = (text: string) => {
    this.activeGptOutput = text;
  }

  interruptVoiceAI() {
    if (this.ttsPlayer) {
      this.ttsPlayer.clear()
      this.ttsPlayer.destroy()
      this.ttsPlayer = null
    }
  }

  loadGptAnswer = async () => {
    this.isLoading = true;

    this.interruptVoiceAI();

    const ttsPlayer = createPlayerTTS()
    this.ttsPlayer = ttsPlayer; // ttsPlayer will be used only once

    try {
      const content = 'Continue this conversation with a one- or two-sentence response: ' + this.activeUserInput;
      console.log('content', content)
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
      ttsPlayer.destroy()
      console.error('loadGptAnswer', e);
    }

    this.activeGptOutput = '';
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
