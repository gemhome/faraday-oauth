# Faraday OAuth1

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/gemhome/faraday-oauth1/ci)](https://github.com/gemhome/faraday-oauth1/actions?query=branch%3Amain)
[![Gem](https://img.shields.io/gem/v/faraday-oauth1.svg?style=flat-square)](https://rubygems.org/gems/faraday-oauth1)
[![License](https://img.shields.io/github/license/gemhome/faraday-oauth1.svg?style=flat-square)](LICENSE.md)

Faraday OAuth1 Middleware.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday-oauth1'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install faraday-oauth1
```

## Usage

```ruby
require 'faraday'
require 'faraday/oauth1'

base_uri = "https://example.com"
path = "/webservices/has-oauth1"
headers = {}
headers["Content-Type"] ||= "application/x-www-form-urlencoded"
# see https://github.com/laserlemon/simple_oauth for credentials options
credentials = {
  consumer_key: consumer_key,
  consumer_secret: consumer_secret,
  access_token: nil,
  access_token_secret: nil
}.compact
auth_type = "param"
conn = Faraday.new(url: base_uri) do |builder|
  builder.request :oauth1, auth_type, **credentials
  builder.use Faraday::Response::RaiseError
  builder.adapter Faraday.default_adapter
  builder.headers.update(headers) if headers
end
response = conn.get(path)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Then, run `bin/test` to run the tests.

To install this gem onto your local machine, run `rake build`.

To release a new version, make a commit with a message such as "Bumped to 0.0.2" and then run `rake release`.
See how it works [here](https://bundler.io/guides/creating_gem.html#releasing-the-gem).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/gemhome/faraday-oauth1).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
