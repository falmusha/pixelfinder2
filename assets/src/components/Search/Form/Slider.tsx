import * as React from "react";
import { style } from "typestyle";
import Slider, { Range as _Range, Marks } from "rc-slider";

import "../../../../styles/checkbox.scss";

export type RangeValue = {
  min: string;
  max: string;
};

interface Props {
  for: "focal-length" | "aperture" | "shutter-speed" | "iso";
  onChange: (range: RangeValue) => void;
}

interface State {
  disabled: boolean;
}

const MARKS = {
  "focal-length": {
    5: "5mm",
    200: "200mm",
    500: "500mm",
    800: "800mm"
  },
  aperture: {
    "-2": "f/0.5",
    3: "f/2.8",
    8: "f/11.0"
  },
  "shutter-speed": {
    0: "60s",
    6: "1s",
    13: "1/250s",
    17: "1/2000s"
  },
  iso: {
    0: "64 ISO",
    12: "800 ISO",
    28: "32000 ISO"
  }
};

const SHUTTER_SPEEDS = [
  "500",
  "60",
  "30",
  "15",
  "8",
  "4",
  "2",
  "1",
  "1/2",
  "1/4",
  "1/8",
  "1/15",
  "1/30",
  "1/60",
  "1/125",
  "1/250",
  "1/500",
  "1/1000",
  "1/2000",
  "1/4000",
  "1/8000"
];

const ISO = [
  "64",
  "80",
  "100",
  "125",
  "160",
  "200",
  "200",
  "250",
  "320",
  "400",
  "500",
  "640",
  "800",
  "1000",
  "1250",
  "1600",
  "2000",
  "2500",
  "3200",
  "4000",
  "5000",
  "6400",
  "8000",
  "10000",
  "12500",
  "16000",
  "20000",
  "25000",
  "32000",
  "40000",
  "50000",
  "64000"
];

const Range = (Slider as any).createSliderWithTooltip(_Range);

function shutterSpeed(value: number) {
  return SHUTTER_SPEEDS[value];
}

function fstop(value: number) {
  return Math.sqrt(Math.pow(2, value)).toFixed(1);
}

function iso(value: number) {
  return ISO[value];
}

const FocalLengthSlider = (props: Props, state: State) => {
  return (
    <Range
      min={5}
      max={1000}
      defaultValue={[5, 200]}
      marks={MARKS[props.for]}
      disabled={state.disabled}
      tipFormatter={(value: number) => `${value}mm`}
      onChange={(value: number[]) =>
        props.onChange({ min: value[0].toString(), max: value[1].toString() })}
    />
  );
};

const ApertureSlider = (props: Props, state: State) => {
  return (
    <Range
      min={-2}
      max={10}
      step={1}
      defaultValue={[1, 5]}
      marks={MARKS[props.for]}
      disabled={state.disabled}
      tipFormatter={(value: number) => `f/${fstop(value)}`}
      onChange={(value: number[]) =>
        props.onChange({
          min: `${fstop(value[0])}`,
          max: `${fstop(value[1])}`
        })}
    />
  );
};

const ShutterSpeedSlider = (props: Props, state: State) => {
  return (
    <Range
      min={0}
      max={20}
      defaultValue={[1, 5]}
      marks={MARKS[props.for]}
      disabled={state.disabled}
      tipFormatter={(value: number) => `${shutterSpeed(value)}s`}
      onChange={(value: number[]) =>
        props.onChange({
          min: `${shutterSpeed(value[0])}`,
          max: `${shutterSpeed(value[1])}`
        })}
    />
  );
};

const ISOSlider = (props: Props, state: State) => {
  return (
    <Range
      min={0}
      max={31}
      defaultValue={[4, 20]}
      marks={MARKS[props.for]}
      disabled={state.disabled}
      tipFormatter={(value: number) => `${iso(value)}s`}
      onChange={(value: number[]) =>
        props.onChange({
          min: `${iso(value[0])}`,
          max: `${iso(value[1])}`
        })}
    />
  );
};

class FormSlider extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { disabled: true };
  }

  onCheckboxChange = (ev: React.ChangeEvent<HTMLInputElement>) => {
    this.setState({ disabled: !ev.target.checked });
  };

  renderSlider() {
    switch (this.props.for) {
      case "focal-length":
        return FocalLengthSlider(this.props, this.state);
      case "aperture":
        return ApertureSlider(this.props, this.state);
      case "shutter-speed":
        return ShutterSpeedSlider(this.props, this.state);
      case "iso":
        return ISOSlider(this.props, this.state);
      default:
        return null;
    }
  }

  render() {
    return (
      <div className={sliderWrapper}>
        <input
          type="checkbox"
          className={`checkbox`}
          onChange={this.onCheckboxChange}
        />
        {this.renderSlider()}
      </div>
    );
  }
}

const sliderWrapper = style({
  display: "flex",
  flexDirection: "row"
});

const sliderItem = {
  padding: "0px 10px"
};

const checkboxInput = style(sliderItem, {});

export default FormSlider;
