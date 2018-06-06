# Local Time

Local Time makes it easy to display times and dates to users in their local time. Its Rails helpers render `<time>` elements in UTC (making them cache friendly), and its JavaScript component immediately converts those elements from UTC to the browser's local time.

## Installation

1. Add `gem 'local_time'` to your Gemfile.
2. Include `local-time.js` in your application's JavaScript bundle.

    Using the asset pipeline:
    ```js
    //= require local-time
    ```
    Using the [local-time npm package](https://www.npmjs.com/package/local-time):
    ```js
    import LocalTime from "local-time"
    LocalTime.start()
    ```

## Example

```ruby
> comment.created_at
"Wed, 27 Nov 2013 18:43:22 EST -0500"
```

```erb
<%= local_time(comment.created_at) %>
```

Renders:

```html
<time data-format="%B %e, %Y %l:%M%P"
      data-local="time"
      datetime="2013-11-27T23:43:22Z">November 27, 2013 11:43pm</time>
```

And is converted client-side to:

```html
<time data-format="%B %e, %Y %l:%M%P"
      data-local="time"
      datetime="2013-11-27T23:43:22Z"
      title="November 27, 2013 6:43pm EDT"
      data-localized="true">November 27, 2013 6:43pm</time>
```

*(Line breaks added for readability)*

## Time and date helpers

```erb
<%= local_time(time) %>
```

Format with a strftime string (default format shown here)

```erb
<%= local_time(time, '%B %e, %Y %l:%M%P') %>
```

Alias for `local_time` with a month-formatted default

```erb
<%= local_date(time, '%B %e, %Y') %>
```

To set attributes on the time tag, pass a hash as the second argument with a `:format` key and your attributes.

```erb
<%= local_time(time, format: '%B %e, %Y %l:%M%P', class: 'my-time') %>
```

To use a strftime format already defined in your app, pass a symbol as the format.

```erb
<%= local_time(date, :long) %>
```

`I18n.t("time.formats.#{format}")`, `I18n.t("date.formats.#{format}")`, `Time::DATE_FORMATS[format]`, and `Date::DATE_FORMATS[format]` will be scanned (in that order) for your format.

Note: The included strftime JavaScript implementation is not 100% complete. It supports the following directives: `%a %A %b %B %c %d %e %H %I %l %m %M %p %P %S %w %y %Y %Z`

## Time ago helpers

```erb
<%= local_time_ago(time) %>
```

Displays the relative amount of time passed. With age, the descriptions transition from {quantity of seconds, minutes, or hours} to {date + time} to {date}. The `<time>` elements are updated every 60 seconds.

Examples (in quotes):

* Recent: "a second ago", "32 seconds ago", "an hour ago", "14 hours ago"
* Yesterday: "yesterday at 5:22pm"
* This week: "Tuesday at 12:48am"
* This year: "on Nov 17"
* Last year: "on Jan 31, 2012"

## Relative time helpers

Preset time and date formats that vary with age. The available types are `date`, `time-ago`, `time-or-date`, and `weekday`. Like the `local_time` helper, `:type` can be passed a string or in an options hash.

```erb
<%= local_relative_time(time, 'weekday') %>
<%= local_relative_time(time, type: 'time-or-date') %>
```

**Available `:type` options**

* `date` Includes the year unless it's current. "Apr 11" or "Apr 11, 2013"
* `time-ago` See above. `local_time_ago` calls `local_relative_time` with this `:type` option.
* `time-or-date` Displays the time if it occurs today or the date if not. "3:26pm" or "Apr 11"
* `weekday` Displays "Today", "Yesterday", or the weekday (e.g. Wednesday) if the time is within a week of today.
* `weekday-or-date` Displays the weekday if it occurs within a week or the date if not. "Yesterday" or "Apr 11"


## Configuration

**Internationalization (I18n)**

Local Time includes a [set of default `en` translations](lib/assets/javascripts/src/local-time/config/i18n.coffee) which can be updated directly. Or, you can provide an entirely new set in a different locale:

```js
LocalTime.config.i18n["es"] = {
  date: {
    dayNames: [ … ],
    monthNames: [ … ],
    …
  },
  time: {
    …
  },
  datetime: {
    …
  }
}

LocalTime.config.locale = "es"
```

## Version History

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

---

[![Build Status](https://travis-ci.org/basecamp/local_time.svg?branch=master)](https://travis-ci.org/basecamp/local_time)

[![Sauce Test Status](https://saucelabs.com/browser-matrix/basecamp_local_time.svg)](https://saucelabs.com/u/basecamp_local_time)
