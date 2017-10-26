import * as React from "react";
import { style } from "typestyle";
import Slider, { Range as _Range, Marks } from "rc-slider";

import "../../../../styles/checkbox.scss";

export type Range = { value: { min: string; max: string }; disabled: boolean };

interface Props {
  for: "focal-length" | "aperture" | "shutter-speed" | "iso";
  range: Range;
  onChange: (range: Range) => void;
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

const FocalLengthSlider = (props: Props) => {
  const min = parseInt(props.range.value.min);
  const max = parseInt(props.range.value.max);
  return (
    <Range
      min={5}
      max={1000}
      defaultValue={[min, max]}
      marks={MARKS[props.for]}
      disabled={props.range.disabled}
      tipFormatter={(value: number) => `${value}mm`}
      onChange={(value: number[]) =>
        props.onChange({
          ...props.range,
          value: { min: value[0].toString(), max: value[1].toString() }
        })}
    />
  );
};

const ApertureSlider = (props: Props) => {
  const min = parseInt(props.range.value.min);
  const max = parseInt(props.range.value.max);
  return (
    <Range
      min={-2}
      max={10}
      step={1}
      defaultValue={[min, max]}
      marks={MARKS[props.for]}
      disabled={props.range.disabled}
      tipFormatter={(value: number) => `f/${fstop(value)}`}
      onChange={(value: number[]) =>
        props.onChange({
          ...props.range,
          value: {
            min: `${fstop(value[0])}`,
            max: `${fstop(value[1])}`
          }
        })}
    />
  );
};

const ShutterSpeedSlider = (props: Props) => {
  const min = parseInt(props.range.value.min);
  const max = parseInt(props.range.value.max);
  return (
    <Range
      min={0}
      max={20}
      defaultValue={[min, max]}
      marks={MARKS[props.for]}
      disabled={props.range.disabled}
      tipFormatter={(value: number) => `${shutterSpeed(value)}s`}
      onChange={(value: number[]) =>
        props.onChange({
          ...props.range,
          value: {
            min: `${shutterSpeed(value[0])}`,
            max: `${shutterSpeed(value[1])}`
          }
        })}
    />
  );
};

const ISOSlider = (props: Props) => {
  const min = parseInt(props.range.value.min);
  const max = parseInt(props.range.value.max);
  return (
    <Range
      min={0}
      max={31}
      defaultValue={[min, max]}
      marks={MARKS[props.for]}
      disabled={props.range.disabled}
      tipFormatter={(value: number) => `${iso(value)} ISO`}
      onChange={(value: number[]) =>
        props.onChange({
          ...props.range,
          value: {
            min: `${iso(value[0])}`,
            max: `${iso(value[1])}`
          }
        })}
    />
  );
};

class FormSlider extends React.PureComponent<Props> {
  onCheckboxChange = (ev: React.ChangeEvent<HTMLInputElement>) => {
    this.props.onChange({ ...this.props.range, disabled: !ev.target.checked });
  };

  renderSlider() {
    switch (this.props.for) {
      case "focal-length":
        return FocalLengthSlider(this.props);
      case "aperture":
        return ApertureSlider(this.props);
      case "shutter-speed":
        return ShutterSpeedSlider(this.props);
      case "iso":
        return ISOSlider(this.props);
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
