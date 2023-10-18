import {action, makeObservable, observable,} from "mobx";


type AppMode = 'stephen' | 'developer' | 'grandma'

export class AppStore {

  appMode: AppMode = 'developer'

  constructor() {
    makeObservable(this, {
      appMode: observable,
      changeMode: action,
    })
  }

  changeMode(mode: AppMode) {
    console.log('### change mode', mode);
    this.appMode = mode
  }
}