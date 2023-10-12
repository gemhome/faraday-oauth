# frozen_string_literal: true

require_relative 'oauth1/request'
require_relative 'oauth1/version'

module Faraday
  # The Faraday::OAuth1 middleware main module
  module OAuth1
    # Load middleware with
    #   conn.use Faraday::OAuth1::Request
    #   or
    #   conn.request :oauth1
    Faraday::Request.register_middleware(oauth1: Faraday::OAuth1::Request)
  end
end
