declare module "react-grid-gallery" {
  import * as React from "react";

  export interface GridImageTag {
    value: string;
    title: string;
  }

  export interface ThumbnailCaption {
    value: string;
    title: string;
  }

  export interface GridImage {
    src: string;
    thumbnail: string;
    thumbnailWidth: number;
    thumbnailHeight: number;
    tags?: GridImageTag[];
    isSelected?: boolean;
    caption?: string;
    srcset?: any[];
    customOverlay?: React.ReactElement<any>;
    thumbnailCaption?: string | React.ReactElement<any>;
  }

  export interface GalleryProps {
    images: GridImage[];
    id?: string;
    enableImageSelection?: boolean;
    onSelectImage?: any;
    rowHeight?: number;
    maxRows?: number;
    margin?: number;
    onClickThumbnail?: any;
    lightboxWillOpen?: any;
    lightboxWillClose?: any;
    enableLightbox?: boolean;
    backdropClosesModal?: boolean;
    currentImage?: number;
    preloadNextImage?: boolean;
    customControls?: Element[];
    enableKeyboardInput?: boolean;
    imageCountSeparator?: string;
    isOpen?: boolean;
    onClickImage?: any;
    onClickNext?: any;
    onClickPrev?: any;
    onClose?: any;
    showCloseButton?: boolean;
    showImageCount?: boolean;
    lightboxWidth?: number;
    tileViewportStyle?: any;
    thumbnailStyle?: any;
    showLightboxThumbnails?: boolean;
    onClickLightboxThumbnail?: any;
    tagStyle?: object;
  }

  class Gallery<T = GalleryProps> extends React.Component<T, {}> {}

  export default Gallery;
}
