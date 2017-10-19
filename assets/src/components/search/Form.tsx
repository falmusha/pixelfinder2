import * as React from "react";
import * as Immutable from "immutable";
import { style } from "typestyle";
import Select, { Options, Option } from "react-select";
import Slider, { Range } from "./Form/Slider";
import { Camera, Lens } from "../../client";

import "../../../styles/react-select.scss";
import "../../../styles/rc-slider.scss";

interface Props {
  lenses: Lens[];
  cameras: Camera[];
  onSubmit: (params: Immutable.Map<string, string>) => void;
}

interface State {
  cameraId: string;
  cameraName: string;
  lensId: string;
  lensName: string;
  focalLength: Range;
  aperture: Range;
  shutter: Range;
  iso: Range;
}

class Form extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      cameraId: "",
      cameraName: "",
      lensId: "",
      lensName: "",
      focalLength: { disabled: true, value: { min: "5", max: "200" } },
      aperture: { disabled: true, value: { min: "1", max: "5" } },
      shutter: { disabled: true, value: { min: "1", max: "5" } },
      iso: { disabled: true, value: { min: "4", max: "20" } }
    };
  }

  lensList(): Options {
    return this.props.lenses.map(lens => {
      return { label: lens.name, value: lens.id.toString() };
    });
  }

  camerasList(): Options {
    return this.props.cameras.map(camera => {
      return { label: camera.name, value: camera.id.toString() };
    });
  }

  stateToMap() {
    const { focalLength, aperture, shutter, iso } = this.state;
    let params = Immutable.Map<string, string>()
      .set("camera_id", this.state.cameraId)
      .set("lens_id", this.state.lensId);

    if (!focalLength.disabled) {
      params = params
        .set("min_focal_length", focalLength.value.min)
        .set("max_focal_length", focalLength.value.max);
    }
    if (!aperture.disabled) {
      params = params
        .set("min_aperture", aperture.value.min)
        .set("max_aperture", aperture.value.max);
    }
    if (!shutter.disabled) {
      params = params
        .set("min_shutter", shutter.value.min)
        .set("max_shutter", shutter.value.max);
    }
    if (!iso.disabled) {
      params = params
        .set("min_iso", iso.value.min)
        .set("max_iso", iso.value.max);
    }
    return params;
  }

  onSearchClick = (ev: React.MouseEvent<HTMLButtonElement>) => {
    this.props.onSubmit(this.stateToMap());
  };

  onOptionsChange = (name: "camera" | "lens") => {
    return (option: Option<string>) => {
      const value = option ? option.value || "" : "";
      const label = option ? option.label || "" : "";
      const optionsId = name == "camera" ? "cameraId" : "lensId";
      const optionsName = name == "camera" ? "cameraName" : "lensName";
      this.setState({ [optionsId]: value, [optionsName]: label } as any);
    };
  };

  onSliderChange = (name: keyof State, inverted: boolean = false) => {
    return (range: Range) => {
      let _range = range;
      if (inverted) {
        _range.value.min = range.value.max;
        _range.value.max = range.value.min;
      }
      this.setState({ [name]: _range } as any);
    };
  };

  render() {
    return (
      <div className={formContainerStyle}>
        <div className={formStyle}>
          <div className={formItemStyle}>
            <Select
              value={this.state.cameraId}
              options={this.camerasList()}
              placeholder={"Camera"}
              onChange={this.onOptionsChange("camera")}
            />
          </div>
          <div className={formItemStyle}>
            <Select
              value={this.state.lensId}
              options={this.lensList()}
              placeholder={"Lens"}
              onChange={this.onOptionsChange("lens")}
            />
          </div>
          <div className={formItemStyle}>
            <Slider
              for="focal-length"
              range={this.state.focalLength}
              onChange={this.onSliderChange("focalLength")}
            />
          </div>
          <div className={formItemStyle}>
            <Slider
              for="aperture"
              range={this.state.aperture}
              onChange={this.onSliderChange("aperture")}
            />
          </div>
          <div className={formItemStyle}>
            <Slider
              for="shutter-speed"
              range={this.state.shutter}
              onChange={this.onSliderChange("shutter")}
            />
          </div>
          <div className={formItemStyle}>
            <Slider
              for="iso"
              range={this.state.iso}
              onChange={this.onSliderChange("iso")}
            />
          </div>
          <button onClick={this.onSearchClick} className={formButtonStyle}>
            Search
          </button>
        </div>
      </div>
    );
  }
}

const formContainerStyle = style({
  width: "100%",
  padding: "20px 0px",
  backgroundColor: "#f9f9f9"
});

const formStyle = style({
  display: "flex",
  flexDirection: "row",
  flexWrap: "wrap",
  maxWidth: 600,
  margin: "0 auto"
});

const formItemStyle = style({
  width: "48%",
  marginLeft: "1%",
  marginRight: "1%",
  marginTop: 12,
  marginBottom: 12
});

const formButtonStyle = style({
  width: "100%",
  margin: "10px 0px",
  padding: "6px 20px",
  backgroundColor: "rgba(0, 0, 0, 0.80)",
  border: "1px solid rgba(0, 0, 0, 0.80)",
  fontSize: "18px",
  color: "white",
  transition: "background-color .2s ease-in",
  $nest: {
    "&:hover": {
      backgroundColor: "black",
      border: "1px solid black"
    }
  }
});

export default Form;
