**unreleased** (January 10, 2025)

* Support for future relative dates. `local_relative_time` now defaults to the new `relative` format and handles both times in the past and in the future symmetrically.
* Support for countdown timers with `local_relative_time time future_prefix: "Ends", past_prefix: "Ended"` that transitions from future to past dates seamlessly.
* **Breaking change**: `time-ago` now returns more granular relative near future results such as "in 45 minutes" instead of jumping straight to "on {date}" in a way that is symmetrical with how near past results are presented. Full list of changes:
  - < 10s: a second ago -> n seconds ago (more accurate, previously 0-9s would say "a second")
  - < 60s: today at 2:26pm -> in 44 seconds (symmetrical with past times)
  - < 90s: today at 2:26pm -> in a minute (symmetrical with past times)
  - < 45m: today at 2:26pm -> in 44 minutes (symmetrical with past times)
  - < 90m: today at 2:26pm -> in an hour (symmetrical with past times)
  - < 24h: tomorrow at 1:25pm -> in 23 hours (symmetrical with past times)
  - < 7d: on Jan 14 -> on Tuesday at 2:25pm (more precise for close dates)

**3.0.2** (January 15, 2024)

* No changes, just a test release for the release script

**3.0.1** (January 15, 2024)

* Add ancillary files to release script
  * `Gemfile.lock` and `MIT-LICENSE` were modified by the release script but not committed to the repository as part of releasing.

**3.0.0** (January 15, 2024)

* Add processing indicators
  * `data-processed-at` attribute is added to processed elements
* Disambiguate date and time formats
  * **Breaking change**: Named date formats declared in ruby are given preference when using date helpers. This is only breaking if you have a date format name that conflicts with a time format, and were expecting the time format to be chosen when using a date helper. See README for details.
  * Provided by @alesolano
* Create release script
* Process elements on repeated start calls
  * Calling `LocalTime.start()` multiple times will reprocess all elements
* Leverage Intl.DateTimeFormat for time zone parsing
  * Time zone parsing with `%Z` is now done natively by the browser
  * Known edge cases not supported by the browser are accounted for separately
  * Previous mechanism still in place as a fallback
  * GMT offset displayed as a last resort
  * Add instructions for time zone testing to CONTRIBUTING.md
* Revert "Add ARIA label to improve accessibility"
  * `<time>` elements don't need an aria label
* Update installation instructions
  * Add native support for importmap inclusion
* Add rubocop
* Support 24h time formats
  * Use config.useFormat24 to render formats from `data-format24` instead of `data-format`
  * Rails helpers can automatically find the 24h format based on a provided format name
  * Support for relative time formats provided by @a-nickol
* Modernize the library
  * Replace Blade with Rollup for bundling and Express for testing
  * Remove sprockets, use static imports
  * Update test dependencies (moment, sinon, and rails)

_First-time contributors_: @josefarias, @alesolano, @a-nickol

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
