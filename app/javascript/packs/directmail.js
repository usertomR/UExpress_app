function one_line_height(message) {
  // font_sizeには、数ではなくpxが格納される
  const font_size = window.getComputedStyle(message.getElementsByClassName("content")[0]).getPropertyValue('font-size');
  const float_font_size = parseFloat(font_size)
  // padding14pxの14を足す
  return  float_font_size + 14
}

function message_display_width() {
  const display_left_or_right = ["display_left", "display_right"];
  display_left_or_right.forEach(left_or_right => {
    const messages = document.getElementsByClassName(left_or_right);
    const messages_count = messages.length;
    const body_width = document.body.getBoundingClientRect().width;
    const message_max_width = (8 / 17) * body_width + 58.8;

    for (let i = 0; i < messages_count; i++) {
      // 適用されているcssが、一行用のone_lineか複数行用のmultiple_linesかの判別
      if (messages[i].getElementsByClassName("one_line").length === 1) {
        let message = messages[i].getElementsByClassName("one_line");
        let message_width = message[0].getBoundingClientRect().width;

        if (message_width > message_max_width) {
          // one_lineからmultiple_linesへcssクラスを変換
          if (left_or_right === "display_left") {
            messages[i].classList.add("left_content_background_color");
          } else {
            messages[i].classList.add("right_content_background_color");
          }
          message[0].classList.add("multiple_lines");
          message[0].classList.remove("one_line");
        }
      } else {
        let message = messages[i].getElementsByClassName("multiple_lines");
        let message_height = message[0].getBoundingClientRect().height;
        // one_lineの時の高さ(右辺)と同じかどうか。1文字の高さに満たない10(px)を使用
        // 本当は両オペランドのnumber型の値が同じかどうかを判別したかったが、できなかったためこのようにした
        if (message_height < one_line_height(messages[i]) + 10) {
          if (left_or_right === "display_left") {
            messages[i].classList.remove("left_content_background_color");
          } else {
            messages[i].classList.remove("right_content_background_color");
          }
          message[0].classList.add("one_line");
          message[0].classList.remove("multiple_lines");
        }
      }
    }
  });
}

window.addEventListener("load", message_display_width);
window.addEventListener("resize", message_display_width);

