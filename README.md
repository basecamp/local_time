Local Time is a Rails engine with helpers and JavaScript for displaying times and dates to users in their local time. The helpers render a `<time>` element in UTC and the JavaScript swoops in to convert and format. Because the `<time>` element is only rendered in one timezone, it is ideal for caching.

---

####Example

```erb
<%= local_time(comment.created_at) # comment.created_at => Wed, 27 Nov 2013 18:43:22 EST -0500 %>
```

Renders:

```html
<time data-format="%B %e, %Y %l:%M%P"
      data-local="time"
      datetime="2013-11-27T23:43:22Z">November 27, 2013 11:43pm</time>
```

When the DOM loads, the content is immediately replaced with a local, formatted time:

```html
<time data-format="%B %e, %Y %l:%M%P"
      data-local="time"
      datetime="2013-11-27T23:43:22Z"
      data-localized="true">November 27, 2013 6:43pm</time>
```

*(Line breaks added for readability)*

#### Time and date helpers

```erb
Pass a time and an optional strftime format (default format shown here)
<%= local_time(time, format: '%B %e, %Y %l:%M%P') %>

Alias for local_time with a month-formatted default
<%= local_date(time, format: '%B %e, %Y') %>
```

To use a strftime format already defined in your app, pass a symbol as the format.
```erb
<%= local_time(date, format: :long) %>
```

`I18n.t("time.formats.#{format}")`, `I18n.t("date.formats.#{format}")`, `Time::DATE_FORMATS[format]`, and `Date::DATE_FORMATS[format]` will be scanned (in that order) for your format.

Note: The included strftime JavaScript implementation is not 100% complete. It supports the following directives: `%a %A %b %B %c %d %e %H %I %l %m %M %p %P %S %w %y %Y`

#### Time ago helper

```erb
<%= local_time_ago(time) %>
```

Displays the relative amount of time passed. With age, the descriptions transition from specific quantities to general dates. The `<time>` elements are updated every 60 seconds. Examples (in quotes):

* Recent: "a second ago", "32 seconds ago", "an hour ago", "14 hours ago"
* Yesterday: "yesterday at 5:22pm"
* This week: "Tuesday at 12:48am"
* This year: "on Nov 17"
* Last year: "on Jan 31, 2012"

#### Installation

1. Add `gem 'local_time'` to your Gemfile.
2. Run `bundle install`.
3. Add `//= require local_time` to your JavaScript manifest file (usually found at app/assets/javascripts/application.js).

#### JavaScript events and library compatibility

The included JavaScript does not depend on any frameworks or libraries, and listens for a `DOMContentLoaded` event to run initially. It also listens on `document` for `page:update` if you're using Turbolinks and `ajaxSuccess` if you're using jQuery. This should catch most cases where new `<time>` elements have been added to the DOM and process them automatically. If you're adding new elements in another context, trigger `time:elapse` to process them.

#### JavaScript API

`strftime` and `relativeTimeAgo` are available via the global `LocalTime` object.

```js
> LocalTime.strftime(new Date, "%B %e, %Y %l:%M%P")
"February 9, 2014 12:55pm"

> LocalTime.relativeTimeAgo(new Date(new Date - 60 * 1000 * 5))
"5 minutes ago"
```

#### Version History

**0.3.0** (February 9, 2014)

* Allow :format option lookup in I18n or DATE_FORMATS hashes [Paul Dobbins]
* Expose public API to JavaScript helpers

**0.2.0** (December 10, 2013)

* Prefer `textContent` over `innerText` for Firefox compatibility
* Added `options` argument to `local_time_ago` helper

**0.1.0** (November 29, 2013)

* Initial release.
