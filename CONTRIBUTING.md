# Contributing
## Getting started
Install the following dependencies:

1. Ruby (version found [here](./.ruby-version))
2. [bundler](https://bundler.io/)
3. [yarn](https://yarnpkg.com/)

Then, open your console on the project directory and run `bundle install` and `yarn install`.

Finally, run `rake assets:compile`.

## Running Tests
This library has a Ruby component and a JavaScript component. Each component has its own test suite.

To run both suites, open your console and run `rake test` from the project directory.

Ruby tests will run first. You will then be prompted to open your web browser to run the JavaScript tests.

## Releasing

Run `bin/release x.y.z`, use `--dry` to skip publishing. This is not idempotent. If releasing fails, take note of where the process left off and continue manually.
