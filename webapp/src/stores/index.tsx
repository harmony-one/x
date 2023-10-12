import { createStoresContext } from './create-context';
import { ChatGptStore } from './ChatGptStore';

export interface IStores {
  chatGpt: ChatGptStore,
}

const stores: IStores = {
  chatGpt: new ChatGptStore()
};

const { StoresProvider, useStores } = createStoresContext<typeof stores>();
export { StoresProvider, useStores };

//@ts-ignore
window.stores = stores;

export default stores;
