// Run this example by adding <%= javascript_pack_tag 'spa_entrypoint' %> to the head of your layout file,
// like app/views/layouts/application.html.erb.

import { App } from '../App';
import React from 'react';
import ReactDOM from 'react-dom';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App />,
    document.getElementsByClassName("for_react_spa")[0]
  )
})
