import { createStoresContext } from './create-context';
import { ChatGptStore } from './ChatGptStore';
import {AppStore} from "./AppStore";

export interface IStores {
  chatGpt: ChatGptStore,
  app: AppStore,
}

const stores: IStores = {
  chatGpt: new ChatGptStore(),
  app: new AppStore(),
};

const { StoresProvider, useStores } = createStoresContext<typeof stores>();
export { StoresProvider, useStores };

//@ts-ignore
window.stores = stores;

export default stores;
