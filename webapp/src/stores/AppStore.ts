import {action, makeObservable, observable,} from "mobx";


export type AppMode = 'production' | 'developer' | 'grandma'

export class AppStore {

  appMode: AppMode = 'production'

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