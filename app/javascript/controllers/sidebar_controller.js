import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = [ "mobileSidebar" ]

  close() {
    this.mobileSidebarTarget.classList.add("hidden");
  }

  open() {
    this.mobileSidebarTarget.classList.remove("hidden");
  }
}
