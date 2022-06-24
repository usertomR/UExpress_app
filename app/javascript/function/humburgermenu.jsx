// ハンバーガーメニューを動作させるためのjsxファイル

import { useEffect } from "react";

export const HunburgerMenu = () => {
  useEffect(() => {
    // 必要な要素の取得・設定
    let body_element = document.getElementsByClassName("for_react_spa")[0];
    const header_button = document.getElementsByClassName("header_btn")[0];
    const area_not_header_not_menu = document.getElementsByClassName("not_menu")[0];
    const hidden_screen = document.getElementsByClassName("hidden_screen")[0];
    const header_menu = document.getElementsByClassName("header_menu")[0];
    const header_menu_links = header_menu.getElementsByTagName("a");
    // hidden_screenは、デフォルトでは映らない。すなわち、デフォルトでは、サイドメニューは表示されない。
    hidden_screen.style.display = "none";

    // サイドメニューの表示、非表示の切り替えの関数
    function motion_humburgermenu() {
      body_element = document.getElementsByClassName("for_react_spa")[0];
      console.log(body_element)
      if (hidden_screen.style.display == "none") {
        // サイドメニューの表示
        hidden_screen.style.display = "block";
        body_element.setAttribute("class","noscroll for_react_spa");
      } else {
        // サイドメニューの非表示
        hidden_screen.style.display = "none";
        body_element.setAttribute("class","for_react_spa");
      }
    }

    // サイドメニューの表示・非表示のトリガー
    header_button.addEventListener('click',motion_humburgermenu);
    area_not_header_not_menu.addEventListener('click',motion_humburgermenu);
    for (let i = 0; i < header_menu_links.length; i++) {
      header_menu_links[i].addEventListener('click',motion_humburgermenu);
    }
  },[]);
}
