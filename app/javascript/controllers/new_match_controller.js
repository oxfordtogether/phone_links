import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ['podId'];

  filterCallersAndCallees(event) {
    event.preventDefault();
    this.stimulate("NewMatchReflex#filter_callers_and_callees", this.podIdTarget.value);
  }
}

