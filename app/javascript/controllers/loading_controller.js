import { Controller } from "@hotwired/stimulus"

// Toggles a busy state on the results frame while a Turbo Frame
// request triggered by the filters form is in flight.
export default class extends Controller {
  static targets = ["frame"]

  connect() {
    this.onBeforeFetch = this.onBeforeFetch.bind(this)
    this.onFrameRender = this.onFrameRender.bind(this)
    document.addEventListener("turbo:before-fetch-request", this.onBeforeFetch)
    document.addEventListener("turbo:frame-render", this.onFrameRender)
  }

  disconnect() {
    document.removeEventListener("turbo:before-fetch-request", this.onBeforeFetch)
    document.removeEventListener("turbo:frame-render", this.onFrameRender)
  }

  onBeforeFetch(event) {
    if (!this.frameTarget.contains(event.target) && event.target !== this.frameTarget) return
    this.frameTarget.setAttribute("aria-busy", "true")
  }

  onFrameRender(event) {
    if (event.target !== this.frameTarget) return
    this.frameTarget.removeAttribute("aria-busy")
  }
}
