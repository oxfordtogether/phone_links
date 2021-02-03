import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import "channels";

import "css/application.css";

import debounced from "debounced";
debounced.initialize();

Rails.start();
Turbolinks.start();
Turbolinks.setProgressBarDelay(200)

import "controllers"
