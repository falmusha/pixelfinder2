import * as React from "react";
import * as Immutable from "immutable";
import { style } from "typestyle";
import Select, { Options, Option } from "react-select";
import Slider, { RangeValue } from "./Form/Slider";
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
  minFocalLength: string;
  maxFocalLength: string;
  minAperture: string;
  maxAperture: string;
  minShutter: string;
  maxShutter: string;
  minISO: string;
  maxISO: string;
}

class Form extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      cameraId: "",
      cameraName: "",
      lensId: "",
      lensName: "",
      minFocalLength: "",
      maxFocalLength: "",
      minAperture: "",
      maxAperture: "",
      minShutter: "",
      maxShutter: "",
      minISO: "",
      maxISO: ""
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
    let sMap = Immutable.Map<string, string>();
    return sMap
      .set("camera_id", this.state.cameraId)
      .set("lens_id", this.state.lensId)
      .set("min_focal_length", this.state.minFocalLength)
      .set("max_focal_length", this.state.maxFocalLength)
      .set("min_aperture", this.state.minAperture)
      .set("max_aperture", this.state.maxAperture)
      .set("min_shutter", this.state.minShutter)
      .set("max_shutter", this.state.maxShutter)
      .set("min_iso", this.state.minISO)
      .set("max_iso", this.state.maxISO);
  }

  onCameraChange = (option: Option<string>) => {
    if (option) {
      this.setState({
        cameraId: option.value || "",
        cameraName: option.label || ""
      });
    }
  };

  onLensChange = (option: Option<string>) => {
    if (option) {
      this.setState({
        lensId: option.value || "",
        lensName: option.label || ""
      });
    }
  };

  onFocalLengthChange = (range: RangeValue) => {
    this.setState({ minFocalLength: range.min, maxFocalLength: range.max });
  };

  onApertureChange = (range: RangeValue) => {
    this.setState({ minAperture: range.min, maxAperture: range.max });
  };

  onShutterChange = (range: RangeValue) => {
    // this is intentionally inverted for UX
    this.setState({ minShutter: range.max, maxShutter: range.min });
  };

  onISOChange = (range: RangeValue) => {
    this.setState({ minISO: range.min, maxISO: range.max });
  };

  onSearchClick = (ev: React.MouseEvent<HTMLButtonElement>) => {
    this.props.onSubmit(this.stateToMap());
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
              onChange={this.onCameraChange}
            />
          </div>
          <div className={formItemStyle}>
            <Select
              value={this.state.lensId}
              options={this.lensList()}
              placeholder={"Lens"}
              onChange={this.onLensChange}
            />
          </div>
          <div className={formItemStyle}>
            <Slider for="focal-length" onChange={this.onFocalLengthChange} />
          </div>
          <div className={formItemStyle}>
            <Slider for="aperture" onChange={this.onApertureChange} />
          </div>
          <div className={formItemStyle}>
            <Slider for="shutter-speed" onChange={this.onShutterChange} />
          </div>
          <div className={formItemStyle}>
            <Slider for="iso" onChange={this.onISOChange} />
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
