import {action, makeObservable, observable,} from "mobx";


type AppMode = 'stephen' | 'developer' | 'grandma'

export class AppStore {

  appMode: AppMode = 'stephen'
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
    if(this.appMode === 'stephen') {
      this.muted = false
    }
  }

  toggleMute(mode?: AppMode) {
      this.muted = !this.muted;
  }
}