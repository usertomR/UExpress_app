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
    const display_left_or_right = ["display_left", "display_right"];
    let message = "該当するhtml要素が代入されます";
    let message_width = "各メッセージの横幅が代入されます";

    function change_message_width() {
      display_left_or_right.forEach(left_or_right => {
        const messages = document.getElementsByClassName(left_or_right);
        const messages_count = messages.length;
        const body_width = document.body.getBoundingClientRect().width;
        const message_max_width = (8 / 17) * body_width + 38.8;
        const seventy_vw = body_width * 0.7;

        for (let i = 0; i < messages_count; i++) {
          message = messages[i];
          // 各々のメッセージのwidthを測定するために、cssクラスを「一旦」変える
          message.classList.add("for_width_check");
          message.classList.remove(left_or_right);
          message_width = message.getBoundingClientRect().width;

          message.classList.add(left_or_right);
          message.classList.remove("for_width_check");
          // 左辺が右辺より小さければ、 messageの横幅の表示領域を適切に狭くする。
          // 左辺の+ 20は、body_widthにあるpadding 20px分を考慮して記入した文字。
          if (message_width + 20 < message_max_width) {
            message.style.width = message_width + 20 + "px";
            if (left_or_right === "display_right") {
              message.style.marginLeft = (seventy_vw - (message_width + 20) - 20) + "px";
            }
          } else {
            message.style.marginLeft = ""
          }
        }
      });
    }

    function delete_style_width() {
      display_left_or_right.forEach(left_or_right => {
        const messages = document.getElementsByClassName(left_or_right);
        const messages_count = messages.length;
        
        for (let i = 0; i < messages_count; i++) {
          message = messages[i];
          message.style.width = "";
        }
      });
    }

    const post_user_avater_name_area = document.getElementsByClassName("my_info")[0];
    const post_user_name_area = post_user_avater_name_area.getElementsByClassName("name_area")[0];
    const post_user_name = post_user_name_area.innerText;
    const post_dates = document.getElementsByClassName("date_display");
    let message_display = document.getElementsByClassName("message_display")[0];
    const input_message_form = document.getElementsByClassName("input_message_form")[0];
    if (post_dates.length == 0) {
      let date_display = `<div class="date_display">${data.post_date}</div>`;
      message_display.insertAdjacentHTML('afterbegin',date_display);
      date_display = document.getElementsByClassName("date_display")[0];
      if (post_user_name == data.post_user.name) {
        let my_message = (data.message.content).replace(/(\r\n)|\n|\r/g, "<br>");
        const my_message_area = `<div class="display_left">${my_message}</div>`;
        date_display.insertAdjacentHTML('afterend',my_message_area);
        input_message_form.value = '';
        // これがなければ、メッセージ送信者は、リロードボタンの押下・ページ遷移なしに連続でメッセージを送信できない
        document.getElementsByClassName("message_submit_button")[0].disabled = ""
      } else {
        let parter_message = (data.message.content).replace(/(\r\n)|\n|\r/g, "<br>");
        let parter_message_area = `<div class="display_right">${parter_message}</div>`;
        date_display.insertAdjacentHTML('afterend',parter_message_area); 
      }
    } else {
      const last_post_date = post_dates[post_dates.length - 1].innerText;
      message_display = document.getElementsByClassName("message_display")[0];
      if (last_post_date != data.post_date) {
        const date_display = `<div class="date_display">${data.post_date}</div>`;
        message_display.insertAdjacentHTML('beforeend',date_display);
        message_display = document.getElementsByClassName("message_display")[0];
        if (post_user_name == data.post_user.name) {
          let my_message = (data.message.content).replace(/(\r\n)|\n|\r/g, "<br>");
          const my_message_area = `<div class="display_left">${my_message}</div>`;
          message_display.insertAdjacentHTML('beforeend',my_message_area);
          input_message_form.value = '';
          // これがなければ、メッセージ送信者は、リロードボタンの押下・ページ遷移なしに連続でメッセージを送信できない
          document.getElementsByClassName("message_submit_button")[0].disabled = ""
        } else {
          let parter_message = (data.message.content).replace(/(\r\n)|\n|\r/g, "<br>");
          let parter_message_area = `<div class="display_right">${parter_message}</div>`;
          message_display.insertAdjacentHTML('beforeend',parter_message_area);
        }
      } else {
        if (post_user_name == data.post_user.name) {
          let my_message = (data.message.content).replace(/(\r\n)|\n|\r/g, "<br>");
          const my_message_area = `<div class="display_left">${my_message}</div>`;
          message_display.insertAdjacentHTML('beforeend',my_message_area);
          input_message_form.value = '';
          // これがなければ、メッセージ送信者は、リロードボタンの押下・ページ遷移なしに連続でメッセージを送信できない
          document.getElementsByClassName("message_submit_button")[0].disabled = ""
        } else {
          let parter_message = (data.message.content).replace(/(\r\n)|\n|\r/g, "<br>");
          let parter_message_area = `<div class="display_right">${parter_message}</div>`;
          message_display.insertAdjacentHTML('beforeend',parter_message_area);
        }
      }
    }
    // メッセージを打ったら実行
    delete_style_width();
    change_message_width();
  }
});
