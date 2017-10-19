import * as Immutable from "immutable";

export function fuzzySearch(query: string, str: string): boolean {
  // courstey of https://github.com/bevacqua/fuzzysearch
  if (query.length == 0) {
    return false;
  }

  let hlen = str.length;
  let nlen = query.length;
  if (nlen > hlen) {
    return false;
  }
  if (nlen == hlen) {
    return query == str;
  }
  outer: for (var i = 0, j = 0; i < nlen; i++) {
    var nch = query.charCodeAt(i);
    while (j < hlen) {
      if (str.charCodeAt(j++) === nch) {
        continue outer;
      }
    }
    return false;
  }
  return true;
}

export type PhotoMeta = {
  height: number;
  width: number;
};

export function getPhotoMeta(url: string): Promise<PhotoMeta> {
  return new Promise((resolve, reject) => {
    let img = new Image();
    img.addEventListener("load", ev => {
      const currentImg: any = ev.currentTarget;
      resolve({
        height: currentImg.naturalHeight,
        width: currentImg.naturalWidth
      });
    });
    img.addEventListener("error", ev => {
      resolve(undefined);
    });
    img.src = url;
  });
}
