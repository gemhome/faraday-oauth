# Faraday OAuth

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/gemhome/faraday-oauth/ci)](https://github.com/gemhome/faraday-oauth/actions?query=branch%3Amain)
[![Gem](https://img.shields.io/gem/v/faraday-oauth.svg?style=flat-square)](https://rubygems.org/gems/faraday-oauth)
[![License](https://img.shields.io/github/license/gemhome/faraday-oauth.svg?style=flat-square)](LICENSE.md)

Faraday OAuth Middleware.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday-oauth'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install faraday-oauth
```

## Usage

```ruby
require 'faraday'
require 'faraday/oauth'

conn = Faraday.new do |builder|
  # CODE HERE
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Then, run `bin/test` to run the tests.

To install this gem onto your local machine, run `rake build`.

To release a new version, make a commit with a message such as "Bumped to 0.0.2" and then run `rake release`.
See how it works [here](https://bundler.io/guides/creating_gem.html#releasing-the-gem).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/gemhome/faraday-oauth).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
