/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS104: Avoid inline assignments
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "./local_time";

let started = false;

const domReady = function() {
  if (document.attachEvent) {
    return document.readyState === "complete";
  } else {
    return document.readyState !== "loading";
  }
};

const nextFrame = function(fn) {
  let left;
  return (left = (typeof requestAnimationFrame === 'function' ? requestAnimationFrame(fn) : undefined)) != null ? left : setTimeout(fn, 17);
};

const startController = function() {
  const controller = LocalTime.getController();
  return controller.start();
};

LocalTime.start = function() {
  if (started) {
    return LocalTime.run();
  } else {
    started = true;
    if ((typeof MutationObserver !== 'undefined' && MutationObserver !== null) || domReady()) {
      return startController();
    } else {
      return nextFrame(startController);
    }
  }
};

if (window.LocalTime === LocalTime) {
  LocalTime.start();
}
