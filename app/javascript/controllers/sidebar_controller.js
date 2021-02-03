import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = [ "mobileSidebar" ]

  close(event) {
    event.preventDefault()
    this.mobileSidebarTarget.classList.add("hidden");
  }

  open(event) {
    event.preventDefault()
    this.mobileSidebarTarget.classList.remove("hidden");
  }
}
