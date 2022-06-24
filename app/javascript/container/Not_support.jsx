// ほとんどFirstreact.jsxと同じです。
// export する関数名とその関数のreturnが違うだけです。

import React, { useReducer, useEffect } from "react";
import axios from "axios";
// url
import { DEFAULT_API_LOCALHOST } from "../url_spa";
const first_sending_url = `${DEFAULT_API_LOCALHOST}/helloworld`;
// component
import { Header } from "../components/header";
// function
import { HunburgerMenu } from "../function/humburgermenu";
// reducers
import {
  initialState,
  FristReactActionTypes,
  FirstReactReducer,
} from '../reducers/Fristreact';

export const NotSupport = () => {
  const [state, dispatch] = useReducer(FirstReactReducer, initialState);
  // 初回レンダリング時のみ実行
  useEffect(() => {
    axios.get(first_sending_url)
    .then(res => {
      dispatch({
        type: FristReactActionTypes.FETCH_SUCCESS,
        payload: {
          login: res.data.login,
          login_and_admin: res.data.login_and_admin,
          user_id: res.data.user.id,
        }
      })
    })
    .catch((e) => {
      console.error(e)
    })
  },[]);

  return (
    <>
      <Header login={state.login} login_and_admin={state.login_and_admin} user_id={state.user_id}/>
      <div className={"z-index_minlevel"}>
        <div className={"message_container"}>
        </div>
        <h1>SPA化未対応</h1>
      </div>
      <HunburgerMenu/>
    </>
  )
  
}