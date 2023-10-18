# frozen_string_literal: true

# Copied from https://github.com/lostisland/faraday_middleware/blob/v1.2.0/lib/faraday_middleware/request/oauth.rb

require 'forwardable'

module Faraday
  module OAuth1
    # Public: Uses the simple_oauth library to sign requests according the
    # OAuth 1 protocol.
    #
    # The options for this middleware are forwarded to SimpleOAuth::Header:
    # :consumer_key, :consumer_secret, :token, :token_secret. All these
    # parameters are optional.
    #
    # The signature is added to the "Authorization" HTTP request header. If the
    # value for this header already exists, it is not overridden.
    #
    # If no Content-Type header is specified, this middleware assumes that
    # request body parameters should be included while signing the request.
    # Otherwise, it only includes them if the Content-Type is
    # "application/x-www-form-urlencoded", as per OAuth 1.0.
    #
    # For better performance while signing requests, this middleware should be
    # positioned before UrlEncoded middleware on the stack, but after any other
    # body-encoding middleware (such as EncodeJson).
    class Request < Middleware
      require 'simple_oauth'

      AUTH_HEADER = 'Authorization'
      CONTENT_TYPE = 'Content-Type'
      TYPE_URLENCODED = 'application/x-www-form-urlencoded'
      DEFAULT_AUTH_METHOD = 'param'
      AUTH_METHODS = [
        DEFAULT_AUTH_METHOD,
        'header'
      ].tap(&:freeze)

      extend Forwardable
      def_delegators :'Faraday::Utils', :parse_nested_query, :parse_query, :build_query

      attr_reader :auth_methods

      def initialize(app = nil, auth_methods = nil, options = {})
        super(app)
        @auth_methods = Array(auth_methods || DEFAULT_AUTH_METHOD)
        validate_auth_methods!
        @options = options
      end

      def on_request(env) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        if sign_request?(env) # rubocop:disable Style/GuardClause
          header = oauth_header(env)
          auth_methods.each do |auth_method|
            case auth_method
            when 'param', :param
              params = {
                'oauth_consumer_key' => header.signed_attributes.fetch(:oauth_consumer_key),
                'oauth_signature_method' => header.signed_attributes.fetch(:oauth_signature_method),
                'oauth_timestamp' => header.signed_attributes.fetch(:oauth_timestamp),
                'oauth_nonce' => header.signed_attributes.fetch(:oauth_nonce),
                'oauth_version' => header.signed_attributes.fetch(:oauth_version),
                'oauth_signature' => header.signed_attributes.fetch(:oauth_signature)
              }
                       .merge(query_params(env[:url]))
              env[:url].query = build_query(params)
            when 'header', :header
              env[:request_headers][AUTH_HEADER] ||= header.to_s
            else
              raise ArgumentError, "invalid auth method: #{auth_method} not in #{AUTH_METHODS.join(', ')}"
            end
          end
        end
      end

      def validate_auth_methods!
        invalid_auth_methods = auth_methods.map(&:to_s) - AUTH_METHODS
        return if invalid_auth_methods.empty?

        raise ArgumentError,
              "invalid auth method(s): #{invalid_auth_methods.join(', ')} not in #{AUTH_METHODS.join(', ')}"
      end

      def oauth_header(env)
        SimpleOAuth::Header.new(env[:method],
                                env[:url].to_s,
                                signature_params(body_params(env)),
                                oauth_options(env))
      end

      def sign_request?(env)
        !!env[:request].fetch(:oauth, true)
      end
      alias process_request? sign_request?

      def oauth_options(env)
        if (extra = env[:request][:oauth]) && extra.is_a?(Hash) && !extra.empty?
          @options.merge extra
        else
          @options
        end
      end

      def body_params(env)
        if include_body_params?(env)
          if env[:body].respond_to?(:to_str)
            parse_nested_query env[:body]
          else
            env[:body]
          end
        end || {}
      end

      def include_body_params?(env)
        # see RFC 5849, section 3.4.1.3.1 for details
        !(type = env[:request_headers][CONTENT_TYPE]) || (type == TYPE_URLENCODED)
      end

      def signature_params(params)
        if params.empty?
          params
        else
          params.reject { |_k, v| v.respond_to?(:content_type) }
        end
      end

      def query_params(url)
        if url.query.nil? || url.query.empty?
          {}
        else
          parse_query url.query
        end
      end
    end
  end
end
