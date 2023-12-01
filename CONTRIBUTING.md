# Contributing
## Getting started
Install the following dependencies:

1. Ruby (version found [here](./.ruby-version))
2. [bundler](https://bundler.io/)
3. [yarn](https://yarnpkg.com/)

Then, open your console on the project directory and run `bundle install` and `yarn install`.

Finally, run `rake assets:compile`.

## Running tests
This library has a Ruby component and a JavaScript component. Each component has its own test suite.

To run both suites, plus an asset compilation check, open your console and run `rake test` from the project directory. Ruby tests will run first. You will then be prompted to open your web browser to run the JavaScript tests.

To only run the JavaScript tests, open your console and run `yarn test` from the project directory.

To only run the Ruby tests, open your console and run `rake test:helpers` from the project directory.

## Testing specific time zones
Stubbing the browser's time zone is fragile. Although we have some automated tests for specific time zones, we also need to do some manual testing as follows:

1. Build the project with `yarn build`.
2. Run `yarn start`.
3. Open http://localhost:9000/time-zone-check in your browser.
4. Choose a location that observes the time zone you want to test for and add it to Chrome's [geolocation presets](https://developer.chrome.com/docs/devtools/settings/locations/).
5. Use Chrome's [location sensor override feature](https://developer.chrome.com/docs/devtools/sensors/#open-sensors) to set your location to the one you chose in step 1.
6. Refresh the page and visually verify the results.

Here's a list of time zones we've had problems with in the past:

TZ identifier     | Standard Abbreviation | DST Abbreviation | Latitude | Longitude
----------------- | --------------------- | ---------------- | -------- | ---------
Asia/Jakarta      | WIB                   | —                | -6.175   | 106.8275
America/Anchorage | AKST                  | AKDT             | 61.2181  | -149.9003
Europe/Paris      | CET                   | CEST             | 48.8576  | 2.3470
Pacific/Honolulu  | HST                   | —                | 21.5376  | -158.0023
Asia/Singapore    | SGT                   | —                | 1.3521   | 103.8198
Europe/Moscow     | MSK                   | —                | 55.7558  | 37.6173
Asia/Shanghai     | CST                   | —                | 31.2304  | 121.4737
Asia/Jerusalem    | IST                   | IDT              | 31.7683  | 35.2137
Asia/Manila       | PHT                   | —                | 14.5995  | 120.9842
