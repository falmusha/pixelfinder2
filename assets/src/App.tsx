import * as React from "react";
import * as ReactDOM from "react-dom";
import Search from "./components/Search";

import "../styles/app.scss";

document.addEventListener("DOMContentLoaded", (ev: Event) => {
  const searchPage = document.getElementById("search-page");
  if (searchPage) {
    ReactDOM.render(<Search />, searchPage);
  }
});
