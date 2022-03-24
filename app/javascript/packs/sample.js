const left_messages = document.getElementsByClassName("display_left");
const left_messages_length = left_messages.length;
const body_width = document.body.getBoundingClientRect().width;
for (let i = 1; i < 3; i++){
  console.log("i = " + i);
}
console.log("長さ:" + left_messages_length);
for (let i = 0; i < 3; i++) {
  let message = left_messages[i].getElementsByClassName("one_line");
  let message_width = message[0].getBoundingClientRect().width;
  

  if (message_width > ((8 / 17) * body_width + 58.8)) {
    left_messages[i].classList.add("content_background_color");
    message[0].classList.add("multiple_lines");
    message[0].classList.remove("one_line");
  }
}
