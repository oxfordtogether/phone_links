import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ["newForm", "newButton", "hideButton"];

  showForm(event) {
    event.preventDefault()
    this.newFormTarget.classList.remove("hidden");
    this.newButtonTarget.classList.add("hidden");
    this.hideButtonTarget.classList.remove("hidden");
  }

  hideForm(event) {
    event.preventDefault()
    this.newFormTarget.classList.add("hidden");
    this.newButtonTarget.classList.remove("hidden");
    this.hideButtonTarget.classList.add("hidden");
  }
}
