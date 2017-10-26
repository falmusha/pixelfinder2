const ExtractTextPlugin = require("extract-text-webpack-plugin");
const path = require("path");

const extractSass = new ExtractTextPlugin({
  filename: "css/bundle.css",
  disable: process.env.NODE_ENV === "development"
});

module.exports = {
  entry: ["./src/App"],
  output: {
    path: path.resolve("../static"),
    filename: "js/bundle.js"
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js"]
  },
  module: {
    rules: [
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
