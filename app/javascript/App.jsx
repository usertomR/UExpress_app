import React from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Route,
} from "react-router-dom";

// 各ページを表示するコンテナを読み込む
import { Firstreact } from '../javascript/container/Firstreact';
import { NotSupport } from './container/Not_support';


export const App = () => {
  return (
    <Router>
      <Routes>
        <Route path='/spa/frontend/helloworld' element={<Firstreact />}>
        </Route>
        <Route path='*' element={<NotSupport />}>
        </Route>
      </Routes>
    </Router>
  )
}