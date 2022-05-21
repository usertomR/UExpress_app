import React from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Route,
} from "react-router-dom";
import { Firstreact } from '../javascript/components/Firstreact';


export const App = () => {
  return (
    <Router>
      <Routes>
        <Route path='/spa/frontend/helloworld' element={<Firstreact />}>
        </Route>
      </Routes>
    </Router>
  )
}