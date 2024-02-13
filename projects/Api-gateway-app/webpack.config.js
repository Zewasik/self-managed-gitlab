const path = require("path")
const nodeExternals = require("webpack-node-externals")

module.exports = {
  entry: "./src/server.ts", // Entry point of the application
  target: "node",
  output: {
    path: path.resolve(__dirname, "build"), // Output directory path
    filename: "bundle.js", // Output bundle file name
    publicPath: "./",
  },
  module: {
    rules: [
      { test: /\.ts$/, use: "ts-loader" },
      { test: /\.yaml$/, use: "file-loader" },
    ],
  },
  resolve: {
    extensions: [".ts", ".js"],
  },
  externals: [nodeExternals()],
}
