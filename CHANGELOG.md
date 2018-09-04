**2.1.0** (September 4, 2018)

* Add support for non-padded numerical strftime values (`%-d`, `%-m`, etc.) [Paco Benavent]

**2.0.1** (June 6, 2018)

* Add `aria-label` attribute to improve accessibility

**2.0.0** (August 7, 2017)

* Add internationalization (I18n) API
* Switch to `MutationObserver` instead of listening for various DOM, Turbolinks, and jQuery events
* Publish JavaScript module on npm
* Drop coffee-rails gem dependency
* Renamed `local_time.js` to `local-time.js`

**1.0.3**

* Improve `%Z` time zone parsing
* Use [Blade](https://github.com/javan/blade) runner for JavaScript tests

**1.0.2** (February 3, 2015)

* Fix displaying future relative dates [Cezary Baginski]

**1.0.1** (December 3, 2014)

* Added `weekday-or-date` option [Chew Choon Keat]

**1.0.0** (April 12, 2014)

* Added `local_relative_time` helper with several built in types
* Allow `:format` (and `:type`) option as a bare string or value in hash
* Added `relativeDate`, `relativeTimeOrDate`, `relativeWeekday` and `run` to the API
* Dropped ineffective `popstate` event listener
* Now in use at [Basecamp](https://basecamp.com/)

**0.3.0** (February 9, 2014)

* Allow :format option lookup in I18n or DATE_FORMATS hashes [Paul Dobbins]
* Expose public API to JavaScript helpers

**0.2.0** (December 10, 2013)

* Prefer `textContent` over `innerText` for Firefox compatibility
* Added `options` argument to `local_time_ago` helper

**0.1.0** (November 29, 2013)

* Initial release.
