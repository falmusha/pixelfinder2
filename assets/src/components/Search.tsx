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
    if (!prevState.photosParams.equals(photosParams)) {
      this.updatePhotos();
    }
  }

  toGridPhotos = (photos: Photo[], photosMeta: PhotoMeta[]) => {
    let thumbnails = photos.map((photo, index) => {
      if (photosMeta[index] === undefined) {
        // This removes images that are invalid (do not exist)
        return undefined;
      } else {
        return {
          src: photo.photo_url,
          thumbnail: photo.thumbnail_url,
          thumbnailWidth: photosMeta[index].width,
          thumbnailHeight: photosMeta[index].height,
          caption: `© ${photo.creator.name} / ${photo.source}`,
          customOverlay: <PhotoGridItemOverlay photo={photo} />,
          thumbnailCaption: <PhotoGridItemCaption photo={photo} />
        };
      }
    });

    return thumbnails.filter(t => {
      return t !== undefined;
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
      return [];
    }
  };

  updatePhotos = async () => {
    let gridPhotos = this.state.gridPhotos;
    try {
      gridPhotos = gridPhotos.concat(await this.fetchPhotos());
    } catch {
      console.error("Couldn't update photos");
    }
    this.setState({ gridPhotos: gridPhotos, isLoading: false });
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

  renderPhotos = () => {
    const { gridPhotos, isLoading } = this.state;
    if (gridPhotos.length > 0) {
      return <PhotoGrid photos={gridPhotos} />;
    }
    if (isLoading) {
      return (
        <span className={gridPlaceholderStyle}>
          (ง •̀_•́)ง Looking for photos
        </span>
      );
    } else {
      return (
        <span className={gridPlaceholderStyle}>No photos found ¯\_(ツ)_/¯</span>
      );
    }
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
        {this.renderPhotos()}
      </div>
    );
  }
}

const searchStyle = style({
  width: "100%",
  display: "flex",
  flexDirection: "column"
});

const gridPlaceholderStyle = style({
  paddingTop: 40,
  margin: "0 auto",
  fontSize: 40
});

export default Search;
