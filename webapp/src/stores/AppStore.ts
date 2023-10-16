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
    this.toggleMute(this.appMode)
  }

  toggleMute(mode?: AppMode) {
    /// in Stephen Mode, always unmuted
    if(mode === 'stephen') {
      this.muted = false
    } else {
      this.muted = !this.muted;
    }
  }
}