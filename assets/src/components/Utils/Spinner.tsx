import * as React from "react";
import { style, keyframes } from "typestyle";

interface Props {
  location: "bottom-right";
}

class Spinner extends React.PureComponent<Props, {}> {
  render() {
    return <div className={spinnerStyle}>Loading...</div>;
  }
}

// const spinnerKeyframe = keyframes({});
const spinnerStyle = style({
  margin: 10,
  padding: 10,
  zIndex: 10,
  background: "rgba(0, 0, 0, 0.8)",
  position: "fixed",
  bottom: 0,
  fontSize: 40,
  color: "white"
});

export default Spinner;
