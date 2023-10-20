import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import mobxStores, { StoresProvider } from './stores';
import { Provider as MobxProvider } from 'mobx-react';
import {Grommet} from "grommet";

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <StoresProvider stores={mobxStores}>
    <MobxProvider {...mobxStores}>
      <Grommet full>
        <BrowserRouter>
          <App />
        </BrowserRouter>
      </Grommet>
    </MobxProvider>
  </StoresProvider>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
