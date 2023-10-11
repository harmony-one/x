import { makeObservable, action, observable, computed } from "mobx";
import OpenAI from 'openai';
import { ttsPlayer } from '../../widgets/tts';
import { isPhraseComplete } from "./helpers";

enum AUTHOR {
  USER = 'user',
  GPT = 'gpt',
}

interface IMessage {
  author: AUTHOR,
  text: string;
}

export class ChatGptStore {
  openai: OpenAI;

  messages: IMessage[] = [];

  activeGptOutput: string = '';
  activeUserInput: string = '';

  isPending: boolean = false;

  constructor() {
    makeObservable(this, {
      isPending: observable,
      messages: observable,
      activeGptOutput: observable,
      activeUserInput: observable,
      setUserInput: action,
      setGptOutput: action,
      loadGptAnswer: action,
      isLoaded: computed,
    })

    this.openai = new OpenAI({
      apiKey: String(process.env.REACT_APP_SECRET_OPEN_AI),
      dangerouslyAllowBrowser: true
  });
  }

  setUserInput = (text: string) => {
    this.activeUserInput = text;
  }

  setGptOutput = (text: string) => {
    this.activeGptOutput = text;
  }

  get isLoaded() {
    return this.isPending
  }

  loadGptAnswer = async () => {
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
  }
}