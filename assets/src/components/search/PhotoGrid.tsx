import * as React from "react";
import * as Gallery from "react-grid-gallery";
import { style } from "typestyle";

interface Props {
  photos: any[];
}

class PhotoGrid extends React.Component<Props, {}> {
  constructor(props: Props) {
    super(props);
  }

  render() {
    const { photos } = this.props;
    const GalleryComponent: any = Gallery;
    return <GalleryComponent images={photos} enableImageSelection={false} />;
  }
}

export default PhotoGrid;
