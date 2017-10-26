const path = require("path");
const merge = require("webpack-merge");
const common = require("./webpack.common.js");

module.exports = merge(common, {
  devtool: "source-map",
  module: {
    rules: [{ test: /\.js$/, use: "source-map-loader", enforce: "pre" }]
  }
});
