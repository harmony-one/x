import { createStoresContext } from './create-context';

export interface IStores {}

const stores: IStores = {};

const { StoresProvider, useStores } = createStoresContext<typeof stores>();
export { StoresProvider, useStores };

//@ts-ignore
window.stores = stores;

export default stores;
