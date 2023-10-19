import { makeObservable, action, observable, computed } from "mobx";
import OpenAI from 'openai';
import {getTTSPlayer, TTSPlayerType} from '../../widgets/tts';
import { isPhraseComplete } from "./helpers";
import ExternalTTSAudioFilePlayer from "../../widgets/tts/audio-file-player";

export enum AUTHOR {
  USER = 'user',
  GPT = 'gpt',
}

export interface IMessage {
  author: AUTHOR,
  text: string;
  inGptContext: boolean
}

export class ChatGptStore {
  openai: OpenAI;
  openAiAbortController?: AbortController

  messages: IMessage[] = [];

  activeGptOutput: string = '';

  isLoading: boolean = false;
  conversationContextLength = 20
  public ttsPlayerType = TTSPlayerType.google
  ttsPlayer: ExternalTTSAudioFilePlayer | null = null;

  constructor() {
    makeObservable(this, {
      ttsPlayerType: observable,
      ttsPlayer: observable,
      isLoading: observable,
      messages: observable,
      activeGptOutput: observable,
      setUserInput: action,
      setGptOutput: action,
      loadGptAnswer: action,
      clearMessages: action,
      loadMessages: action,
      conversationContext: computed,
      interruptOpenAiStream: action,
      setTTSPlayer: action,
    })

    this.openai = new OpenAI({
      apiKey: String(process.env.REACT_APP_SECRET_OPEN_AI),
      dangerouslyAllowBrowser: true
    });

    this.loadMessages();
  }

  get conversationContext () {
    const messagesList = [...this.messages]
      .reverse()
      .filter((message, index) =>
        index < this.conversationContextLength &&
        message.inGptContext
      )
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
      text,
      inGptContext: true
    })
  }

  setGptOutput = (text: string) => {
    this.activeGptOutput = text;
  }

  public interruptOpenAiStream() {
    if(this.openAiAbortController) {
      this.openAiAbortController.abort()
      this.openAiAbortController = undefined

      this.messages = this.messages.map((item, index, arr) => {
        if(index < arr.length - 1) {
          return item
        }
        return {
          ...item,
          inGptContext: false
        }
      })
      if(this.activeGptOutput) {
        this.messages.push({
          author: AUTHOR.GPT,
          text: this.activeGptOutput,
          inGptContext: false
        })
        this.setGptOutput('')
      }

      console.log('OpenAI stream interrupted')
    }
  }

  setTTSPlayer(type: TTSPlayerType) {
    this.ttsPlayerType = type
    this.interruptVoiceAI()
    this.ttsPlayer = getTTSPlayer(type)
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

    const ttsPlayer = getTTSPlayer(this.ttsPlayerType)
    console.log('Init TTS player:', this.ttsPlayerType)
    this.ttsPlayer = ttsPlayer; // ttsPlayer will be used only once

    try {
      const content = 'Continue this conversation with a one- or two-sentence response: ' + this.conversationContext;
      console.log('Send full context to GPT4:', content)
      let resMessage = ''

      ttsPlayer.clear();
      ttsPlayer.play();

      const abortController = new AbortController()
      const stream= await this.openai.chat.completions.create({
        model: 'gpt-4',
        messages: [{ role: 'user', content }],
        stream: true,
        max_tokens: 200,
        temperature: 0.8
      }, {
        signal: abortController.signal
      });
      this.openAiAbortController = stream.controller

      const lines: string[] = [];
      let currentLineIdx = 0;
      let text = '';

      for await (const part of stream) {
        text = (part.choices[0]?.delta?.content || '').replaceAll('"', '');

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

      if(this.activeGptOutput) {
        this.messages.push({
          author: AUTHOR.GPT,
          text: this.activeGptOutput,
          inGptContext: true
        })
      }

      this.saveMessages();
    } catch (e) {
      console.error('GPT4 error', e);
      ttsPlayer.destroy()
    }

    this.openAiAbortController = undefined
    this.activeGptOutput = '';
    this.isLoading = false;
  }

  saveMessages = () => {
    localStorage.setItem('gpt_messages', JSON.stringify(
      this.messages.map(m => m)
    ));
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
