import * as React from "react";
import * as Immutable from "immutable";
import { style } from "typestyle";
import Client, { Camera, Lens, Photo } from "../client";
import { getPhotoMeta, PhotoMeta } from "../utils";
import Form from "./Search/Form";
import PhotoGrid from "./Search/PhotoGrid";
import PhotoGridItemOverlay from "./Search/PhotoGrid/ItemOverlay";
import PhotoGridItemCaption from "./Search/PhotoGrid/ItemCaption";
import Spinner from "./Utils/Spinner";

interface State {
  cameras: Camera[];
  lenses: Lens[];
  photosParams: Immutable.Map<string, string>;
  gridPhotos: any[];
  isLoading: boolean;
}

class Search extends React.Component<{}, State> {
  constructor(props: any) {
    super(props);
    this.state = {
      cameras: [],
      lenses: [],
      photosParams: Immutable.Map({ page: "1" }),
      gridPhotos: [],
      isLoading: true
    };
  }

  componentDidMount() {
    window.addEventListener("scroll", this.onScroll);

    Promise.all([Client.getCameras(), Client.getLenses(), this.fetchPhotos()])
      .then(result => {
        const isLoading = result[2] === undefined;
        this.setState({
          cameras: result[0],
          lenses: result[1],
          gridPhotos: result[2] || [],
          isLoading: isLoading
        });
      })
      .catch(err => {
        console.error(`request failed with ${err.status} (${err.statusText})`);
      });
  }

  componentWillUnmount() {
    window.removeEventListener("scroll", this.onScroll);
  }

  componentDidUpdate(prevProps: any, prevState: State) {
    const { photosParams } = this.state;
    if (prevState.photosParams != photosParams) {
      this.updatePhotos();
    }
  }

  toGridPhotos = (photos: Photo[], photosMeta: PhotoMeta[]) => {
    return photos.map((photo, index) => {
      return {
        src: photo.photo_url,
        thumbnail: photo.thumbnail_url,
        thumbnailWidth: photosMeta[index].width,
        thumbnailHeight: photosMeta[index].height,
        caption: `© ${photo.creator.name} / ${photo.source}`,
        customOverlay: <PhotoGridItemOverlay photo={photo} />,
        thumbnailCaption: <PhotoGridItemCaption photo={photo} />
      };
    });
  };

  fetchPhotos = async () => {
    try {
      const photos = await Client.getPhotos(this.state.photosParams);
      const photosMeta = Promise.all(
        photos.map(photo => {
          return getPhotoMeta(photo.thumbnail_url);
        })
      );
      return this.toGridPhotos(photos, await photosMeta);
    } catch {
      console.error("Couldn't fetch photos");
    }
  };

  updatePhotos = async () => {
    try {
      const newGridPhotos = await this.fetchPhotos();
      if (newGridPhotos) {
        this.setState({
          gridPhotos: this.state.gridPhotos.concat(newGridPhotos),
          isLoading: false
        });
      }
    } catch {
      console.error("Couldn't update photos");
    }
  };

  onScroll = () => {
    if (this.isBottomReached()) {
      let { photosParams } = this.state;
      let page = parseInt(photosParams.get("page") || "1") + 1;
      this.setState({
        photosParams: photosParams.set("page", page.toString()),
        isLoading: true
      });
    }
  };

  isBottomReached = () => {
    const windowHeight =
      "innerHeight" in window
        ? window.innerHeight
        : document.documentElement.offsetHeight;
    const body = document.body;
    const html = document.documentElement;
    const docHeight = Math.max(
      body.scrollHeight,
      body.offsetHeight,
      html.clientHeight,
      html.scrollHeight,
      html.offsetHeight
    );
    const windowBottom = windowHeight + window.pageYOffset;
    if (windowBottom >= docHeight) {
      return true;
    } else {
      return false;
    }
  };

  onSubmitSearch = (params: Immutable.Map<string, string>) => {
    this.setState({
      photosParams: params.set("page", "1"),
      gridPhotos: [],
      isLoading: true
    });
  };

  render() {
    const { cameras, lenses, gridPhotos, isLoading } = this.state;
    return (
      <div className={searchStyle}>
        <Form
          cameras={cameras}
          lenses={lenses}
          onSubmit={this.onSubmitSearch}
        />
        {isLoading ? <Spinner location={"bottom-right"} /> : null}
        {gridPhotos.length > 0 ? <PhotoGrid photos={gridPhotos} /> : null}
      </div>
    );
  }
}

const searchStyle = style({
  width: "100%",
  display: "flex",
  flexDirection: "column"
});

export default Search;
