// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "./local_time";

const {elementMatchesSelector} = LocalTime;

LocalTime.PageObserver = class PageObserver {
  constructor(selector, callback) {
    this.processMutations = this.processMutations.bind(this);
    this.processInsertion = this.processInsertion.bind(this);
    this.selector = selector;
    this.callback = callback;
  }

  start() {
    if (!this.started) {
      this.observeWithMutationObserver() || this.observeWithMutationEvent();
      return this.started = true;
    }
  }

  observeWithMutationObserver() {
    if (typeof MutationObserver !== 'undefined' && MutationObserver !== null) {
      const observer = new MutationObserver(this.processMutations);
      observer.observe(document.documentElement, {childList: true, subtree: true});
      return true;
    }
  }

  observeWithMutationEvent() {
    addEventListener("DOMNodeInserted", this.processInsertion, false);
    return true;
  }

  findSignificantElements(element) {
    const elements = [];
    if ((element != null ? element.nodeType : undefined) === Node.ELEMENT_NODE) {
      if (elementMatchesSelector(element, this.selector)) { elements.push(element); }
      elements.push(...Array.from(element.querySelectorAll(this.selector) || []));
    }
    return elements;
  }

  processMutations(mutations) {
    const elements = [];
    for (var mutation of Array.from(mutations)) {
      switch (mutation.type) {
        case "childList":
          for (var node of Array.from(mutation.addedNodes)) {
            elements.push(...Array.from(this.findSignificantElements(node) || []));
          }
          break;
      }
    }
    return this.notify(elements);
  }

  processInsertion(event) {
    const elements = this.findSignificantElements(event.target);
    return this.notify(elements);
  }

  notify(elements) {
    if (elements != null ? elements.length : undefined) {
      return (typeof this.callback === 'function' ? this.callback(elements) : undefined);
    }
  }
};
