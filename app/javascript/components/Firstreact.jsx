import React from "react";
import classes from "../scss/testcss.module.scss";

export const Firstreact = () => {
  return (
    <div>
      <h1 className={"forh1 "+ classes.forh1}>First React!</h1>
      <h2 className={classes.forh2}>SPA実装していこう!</h2>
    </div>
  )
}