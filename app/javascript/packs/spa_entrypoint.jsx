// Run this example by adding <%= javascript_pack_tag 'spa_entrypoint' %> to the head of your layout file,
// like app/views/layouts/application.html.erb.

import { App } from '../App';
import React from 'react';
import { createRoot } from 'react-dom/client';

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementsByClassName("for_react_spa")[0];
  const root = createRoot(container);
  root.render(<App />);
})
