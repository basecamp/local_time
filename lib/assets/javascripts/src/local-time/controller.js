// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "./local_time";
import "./relative_time";
import "./page_observer";

const {parseDate, strftime, getI18nValue, config} = LocalTime;

(function() {
  let SELECTOR = undefined;
  let markAsLocalized = undefined;
  let relative = undefined;
  const Cls = (LocalTime.Controller = class Controller {
    static initClass() {
      SELECTOR = "time[data-local]:not([data-localized])";
  
      markAsLocalized = element => element.setAttribute("data-localized", "");
  
      relative = time => new LocalTime.RelativeTime(time);
    }

    constructor() {
      this.processElements = this.processElements.bind(this);
      this.pageObserver = new LocalTime.PageObserver(SELECTOR, this.processElements);
    }

    start() {
      if (!this.started) {
        this.processElements();
        this.startTimer();
        this.pageObserver.start();
        return this.started = true;
      }
    }

    startTimer() {
      let interval;
      if (interval = config.timerInterval) {
        return this.timer != null ? this.timer : (this.timer = setInterval(this.processElements, interval));
      }
    }

    processElements(elements) {
      if (elements == null) { elements = document.querySelectorAll(SELECTOR); }
      for (var element of Array.from(elements)) { this.processElement(element); }
      return elements.length;
    }

    processElement(element) {
      const datetime = element.getAttribute("datetime");
      const local = element.getAttribute("data-local");
      const format = config.useFormat24 ?
        element.getAttribute("data-format24") || element.getAttribute("data-format")
      :
        element.getAttribute("data-format");

      const time = parseDate(datetime);
      if (isNaN(time)) { return; }

      if (!element.hasAttribute("title")) {
        const title_format = config.useFormat24 ? "default_24h" : "default";
        const title = strftime(time, getI18nValue(`datetime.formats.${title_format}`));
        element.setAttribute("title", title);
      }

      return element.textContent = (() => { switch (local) {
        case "time":
          markAsLocalized(element);
          return strftime(time, format);
        case "date":
          markAsLocalized(element);
          return relative(time).toDateString();
        case "time-ago":
          return relative(time).toString();
        case "time-or-date":
          return relative(time).toTimeOrDateString();
        case "weekday":
          return relative(time).toWeekdayString();
        case "weekday-or-date":
          return relative(time).toWeekdayString() || relative(time).toDateString();
      } })();
    }
  });
  Cls.initClass();
  return Cls;
})();
