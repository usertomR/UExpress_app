import React from "react";
import { Link } from "react-router-dom";

export const Header = (props) => {
  // 即時関数を利用している。
  return (
    <>
      <header>
        <div className={"header_flex_container"}>
          <div className={"header_logo"}>
            <div className={"logo_position"}>
              UExpress
            </div>
          </div>
          <div className={"header_btn"}>
            <div className={"btn_element"}></div>
            <div className={"btn_element"}></div>
            <div className={"btn_element"}></div>
          </div>
        </div>
      </header>
      <div className={"hidden_screen"}>
        <div className={"not_menu"}>
        </div>
        <div className={"header_menu"}>
          <li className={"header_menu_item"}>
          <Link to="spa/frontend/">Home</Link>
          </li>
          <div className={"header_hirizontal_line"}></div>
          {
            (function () {
              if (props.login === "true") {
                return (
                  <>
                    <li className="header_menu_item"><Link to="spa/frontend/logout">ログアウト</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to={`/spa/frontend/users/${props.user_id}`}>プロフィール</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to={`/spa/frontend/users/${props.user_id}/edit`}>アカウント更新</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to="/spa/frontend/articles/new">記事作成</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to="/spa/frontend/questions/new">プロフィール</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to={`/spa/frontend/user/${props.user_id}/nice`}>記事niceリスト</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to={`/spa/frontend/user/${props.user_id}/bookmark`}>記事ブックマーク</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to={`/spa/frontend/user/${props.user_id}/questionbookmark`}>質問ブックマーク</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to={`/spa/frontend/user/${props.user_id}/curious`}>気になる質問リスト</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to={`/spa/frontend/articles/${props.user_id}`}>記事投稿リスト</Link></li>
                    <div className="header_hirizontal_line"></div>
                    <li className="header_menu_item"><Link to={`/spa/frontend/questions/${props.user_id}`}>質問投稿リスト</Link></li>
                    <div className="header_hirizontal_line"></div>
                  </>
                )
              }
            }())
          }
          {
            (function () {
              if (props.login_and_admin === "true") {
                return (
                  <>
                    <li className="header_menu_item"><Link to="/spa/frontend/users">ユーザー削除</Link></li>
                    <div className="header_hirizontal_line"></div>
                  </>
                )
              }
            }())
          }
        </div>
      </div>
    </>
  )
}
