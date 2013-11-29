Local Time is a Rails engine with helpers and JavaScript for displaying times and dates to users in their local time. The helpers render a `<time>` element in UTC and the JavaScript swoops in to convert and format. Because the `<time>` element is only rendered in one timezone (UTC), it is ideal for caching.

####Example

Assuming the time zone is EST and `Time.now` is `2013-11-27 18:43:22 -0500`:

```erb
<%= local_time(Time.now) # index.html.erb %>
```

Renders:

```html
<time data-format="%B %e, %Y %l:%M%P"
      data-local="time"
      datetime="2013-11-27T23:43:22Z">November 27, 2013 11:43pm</time>
```

And immediately transforms to local time with JavaScript:

```html
<time data-format="%B %e, %Y %l:%M%P"
      data-local="time"
      datetime="2013-11-27T23:43:22Z"
      data-localized="true">November 27, 2013 6:43pm</time>
```

*(Linebreaks added for readability)*

#### Time and date helpers

```erb
Pass a time and an optional strftime format (default format shown here)
<%= local_time(time, format: '%B %e, %Y %l:%M%P') %>

Alias for local_time with a month-formatted default
<%= local_date(time, format: '%B %e, %Y') %>
```

Note: The included strftime JavaScript implementation is not 100% complete. It supports the following directives: `%a %A %b %B %c %d %e %H %I %l %m %M %p %P %S %w %y %Y`

#### Time ago helper

```erb
<%= local_time_ago(time) %>
```

Displays the relative amount of time passed. With age, the descriptions transition from specific quantities to general dates. The `<time>` elements are updated every 60 seconds. Examples:

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

The included JavaScript does not depend on any frameworks or libraries and listens for a `DOMContentLoaded` event to run initially. It also listens on `document` for `page:update` if you're using Turbolinks and `ajaxSuccess` if you're using jQuery. This should catch most cases where new `<time>` elements have been added to the DOM and process them automatically.

If the above events don't catch new elements, you can trigger `time:elapse` to process them. The internal timer triggers the same event every 60 seconds to update all `local_time_ago` generated elements.
