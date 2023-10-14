import {action, makeObservable, observable,} from "mobx";


type AppMode = 'stephen' | 'developer' | 'grandma'

export class AppStore {

  appMode: AppMode = 'developer'
  muted: boolean = false;

  constructor() {
    makeObservable(this, {
      appMode: observable,
      changeMode: action,
      muted: observable,
      toggleMute: action
    })
  }

  changeMode(mode: AppMode) {
    this.appMode = mode
  }

  toggleMute() {
    this.muted = !this.muted;
  }
}