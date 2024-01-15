# Local Time

Local Time makes it easy to display times and dates to users in their local time. Its Rails helpers render `<time>` elements in UTC (making them cache friendly), and its JavaScript component immediately converts those elements from UTC to the browser's local time.

## Installation

### Importmaps
1. Add `gem "local_time"` to your Gemfile.
2. Run `bundle install`
3. Run `bin/importmap pin local-time` to add the [local-time npm package](https://www.npmjs.com/package/local-time)
4. Add this to `app/javascript/application.js`

    ```js
    import LocalTime from "local-time"
    LocalTime.start()
    ```

### Webpacker
1. Add `gem "local_time"` to your Gemfile.
2. Run `bundle install`
3. Run `yarn add local-time`
4. Add this to `app/javascript/packs/application.js`

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

When using the `local_time` helper `I18n.t("time.formats.#{format}")`, `I18n.t("date.formats.#{format}")`, `Time::DATE_FORMATS[format]`, and `Date::DATE_FORMATS[format]` will be scanned (in that order) for your format.

When using the `local_date` helper, `I18n.t("date.formats.#{format}")`, `I18n.t("time.formats.#{format}")`, `Date::DATE_FORMATS[format]`, and `Time::DATE_FORMATS[format]` will be scanned (in that order) for your format.

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

**24-hour time formatting**
Local Time supports 24-hour time formats out of the box.

To use this feature, configure the library to favor `data-format24` over `data-format` attributes:

```js
LocalTime.config.useFormat24 = true
```

The library will now default to using the `data-format24` attribute on `<time>` elements for formatting.
But it will still fall back to `data-format` if `data-format24` is not provided.

The included Rails helpers will automatically look for 24h variants of named formats.
They will search for `#{name}_24h` in [the same places](#time-and-date-helpers) the regular name is looked up.

This is an example of what your app configuration might look like:

```ruby
Time::DATE_FORMATS[:simple] = "%-l:%M%P"
Time::DATE_FORMATS[:simple_24h] = "%H:%M"
```

When `:type` is set to `time-ago`, the format is obtained from the `I18n` [configuration](#configuration).

In practice, you might set `config.useFormat24` to `true` or `false` depending on the current user's configuration, before rendering any `<time>` elements.

## Contributing
Please read [CONTRIBUTING.md](./CONTRIBUTING.md).
