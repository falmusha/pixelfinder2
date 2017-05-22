import * as Immutable from "immutable";

export type Camera = {
  id: number;
  name: string;
};

export type Lens = {
  id: number;
  name: string;
};

export type Creator = {
  id: number;
  name: string;
};

export type Photo = {
  id: number;
  page_url: string;
  thumbnail_url: string;
  photo_url: string;
  source: string;
  creator: Creator;
};

type ResponseError = {
  status: string;
  statusText: string;
};

function get(
  endpoint: string,
  params?: Immutable.Map<string, string>
): Promise<any> {
  return new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = (ev: Event) => {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          resolve(xhr.response);
        } else {
          reject({
            status: xhr.status,
            statusText: xhr.statusText
          });
        }
      }
    };
    let p = "";
    if (params != undefined && params.size > 0) {
      p = params
        .filter((v, k, _) => {
          return v.length > 0;
        })
        .reduce((reduction, v, k, _) => {
          return `${reduction}${k}=${v}&`;
        }, "?");
    }
    xhr.open("GET", encodeURI(`${endpoint}${p}`), true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send();
  });
}

function getCameras(): Promise<Camera[]> {
  return new Promise((resolve, reject) => {
    get("/api/cameras")
      .then((result: string) => {
        let cameras: Camera[] = JSON.parse(result);
        resolve(cameras);
      })
      .catch((err: ResponseError) => {
        reject(
          new Error(
            `getCameras(): request failed with ${err.status} (${err.statusText})`
          )
        );
      });
  });
}

function getLenses(): Promise<Lens[]> {
  return new Promise((resolve, reject) => {
    get("/api/lenses")
      .then((result: string) => {
        let lenses: Lens[] = JSON.parse(result);
        resolve(lenses);
      })
      .catch((err: ResponseError) => {
        reject(
          new Error(
            `getLenses(): request failed with ${err.status} (${err.statusText})`
          )
        );
      });
  });
}

function getPhotos(params?: Immutable.Map<string, string>): Promise<Photo[]> {
  return new Promise((resolve, reject) => {
    get("/api/photos", params)
      .then((result: string) => {
        let photos: Photo[] = JSON.parse(result);
        resolve(photos);
      })
      .catch((err: ResponseError) => {
        reject(
          new Error(
            `getPhotos(): request failed with ${err.status} (${err.statusText})`
          )
        );
      });
  });
}

export default {
  getCameras,
  getLenses,
  getPhotos
};
