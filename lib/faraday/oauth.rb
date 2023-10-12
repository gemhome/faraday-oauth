# frozen_string_literal: true

require_relative 'oauth/request'
require_relative 'oauth/version'

module Faraday
  # The Faraday::OAuth middleware main module
  module OAuth
    # Load middleware with
    #   conn.use Faraday::OAuth::Request
    #   or
    #   conn.request :oauth
    Faraday::Request.register_middleware(oauth: Faraday::OAuth::Request)
  end
end
