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
      }
    }
  });
}
 
function delete_style() {
  display_left_or_right.forEach(left_or_right => {
    const messages = document.getElementsByClassName(left_or_right);
    const messages_count = messages.length;
    
    for (let i = 0; i < messages_count; i++) {
      message = messages[i];
      message.style.width = "";
    }
  });
}

// ページアクセス時に実行
change_message_width();
// アクセス時に実行した際に指定したmessage.style.widthの値をリセットする
window.addEventListener("resize", delete_style);
window.addEventListener("resize", change_message_width);
