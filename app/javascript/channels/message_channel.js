// サーバーから送られてきたデータをクライアントに描画するためのファイル

import consumer from "./consumer"

consumer.subscriptions.create("MessageChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
    const test_html = `<h1>${data.content.content}</h1>`;
    const message_count = document.getElementsByClassName("display_left").length;
    const last_message = document.getElementsByClassName("display_left")[message_count - 1];
    last_message.insertAdjacentHTML('afterend',test_html);
  }
});
