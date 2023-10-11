import { makeObservable, action, observable, computed } from "mobx";

export class ChatGptStore {
  isPending: boolean = true;

  constructor() {
    makeObservable(this, {
      isPending: observable,
      init: action,
      isLoaded: computed,
    })

  }

  async init() {
    this.isPending = true;
  }

  get isLoaded() {
    return this.isPending
  }
}