import LocalTime from "./local_time"

const { elementMatchesSelector } = LocalTime

LocalTime.PageObserver = class PageObserver {
  constructor(selector, callback) {
    this.selector = selector
    this.callback = callback
    this.processMutations = this.processMutations.bind(this)
    this.processInsertion = this.processInsertion.bind(this)
  }

  start() {
    if (!this.started) {
      this.observeWithMutationObserver() || this.observeWithMutationEvent()
      this.started = true
    }
  }

  observeWithMutationObserver() {
    if (typeof MutationObserver !== "undefined" && MutationObserver !== null) {
      const observer = new MutationObserver(this.processMutations)
      observer.observe(document.documentElement, { childList: true, subtree: true })
      return true
    }
    return false
  }

  observeWithMutationEvent() {
    addEventListener("DOMNodeInserted", this.processInsertion, false)
    return true
  }

  findSignificantElements(element) {
    const elements = []
    if (element?.nodeType === Node.ELEMENT_NODE) {
      if (elementMatchesSelector(element, this.selector)) elements.push(element)
      elements.push(...Array.from(element.querySelectorAll(this.selector) || []))
    }
    return elements
  }

  processMutations(mutations) {
    const elements = []
    for (const mutation of mutations) {
      if (mutation.type === "childList") {
        for (const node of mutation.addedNodes) {
          elements.push(...this.findSignificantElements(node) || [])
        }
      }
    }
    this.notify(elements)
  }

  processInsertion(event) {
    const elements = this.findSignificantElements(event.target)
    this.notify(elements)
  }

  notify(elements) {
    if (elements?.length > 0) {
      if (typeof this.callback === "function") {
        this.callback(elements)
      }
    }
  }
}
