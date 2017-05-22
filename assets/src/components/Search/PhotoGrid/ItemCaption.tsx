import * as React from "react";
import { style } from "typestyle";
import { Photo } from "../../../client";

interface Props {
  photo: Photo;
}

class ItemCaption extends React.Component<Props, {}> {
  _copyright = () => {
    const { photo } = this.props;
    return `© ${photo.creator.name} / ${photo.source}`;
  };

  render() {
    const { photo } = this.props;
    return (
      <div className={captionStyle}>
        <a href={photo.page_url} className={linkStyle}>
          <span className={spanStyle}>{`@${photo.source}`}</span>
        </a>
      </div>
    );
  }
}

const captionStyle = style({
  background: "rgba(0, 0, 0, 0.8)",
  padding: "2px 4px"
});

const linkStyle = style({ color: "white", textDecoration: "none" });

const spanStyle = style({ fontSize: 13 });

export default ItemCaption;
