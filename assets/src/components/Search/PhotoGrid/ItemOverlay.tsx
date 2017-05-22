import * as React from "react";
import { style } from "typestyle";
import { Photo } from "../../../client";

interface Props {
  photo: Photo;
}

class ItemOverlay extends React.Component<Props, {}> {
  _copyright = () => {
    const { photo } = this.props;
    return `© ${photo.creator.name} / ${photo.source}`;
  };

  render() {
    const { photo } = this.props;
    return <span className={overlayStyle}>{this._copyright()}</span>;
  }
}

const overlayStyle = style({
  padding: 1,
  paddingLeft: 5,
  color: "white",
  fontSize: 15
});

export default ItemOverlay;
