import React, { useReducer, useEffect } from "react";
import axios from "axios";
// scss
import classes from "../scss/testcss.module.scss";
// url
import { DEFAULT_API_LOCALHOST } from "../url_spa";
const first_sending_url = `${DEFAULT_API_LOCALHOST}/helloworld`;
// componemt
import { Header } from "../components/header";
// reducers
import {
  initialState,
  FristReactActionTypes,
  FirstReactReducer,
} from "../reducers/Fristreact";
// constant
import { REQUEST_STATE } from "../constant";


export const Firstreact = () => {
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
        <h1 className={"forh1 "+ classes.forh1}>First React!</h1>
        <h2 className={classes.forh2}>SPA実装していこう!</h2>
      </div>
    </>
  )
}