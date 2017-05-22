const ExtractTextPlugin = require("extract-text-webpack-plugin");
const path = require("path");

const extractSass = new ExtractTextPlugin({
  filename: "css/bundle.css",
  disable: process.env.NODE_ENV === "development"
});

var config = {
  entry: ["./src/App"],
  output: {
    path: path.resolve("../static"),
    filename: "js/bundle.js"
  },
  devtool: "source-map",
  resolve: {
    extensions: [".ts", ".tsx", ".js"]
  },
  module: {
    rules: [
      { test: /\.js$/, use: "source-map-loader", enforce: "pre" },
      { test: /\.tsx?$/, use: "ts-loader" },
      { test: /\.css$/, use: ["style-loader", "css-loader"] },
      {
        test: /\.scss$/,
        use: extractSass.extract({
          use: ["css-loader", "sass-loader"],
          fallback: "style-loader"
        })
      }
    ]
  },
  plugins: [extractSass]
};

module.exports = config;
