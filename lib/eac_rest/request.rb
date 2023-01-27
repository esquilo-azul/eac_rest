# frozen_string_literal: true

require 'eac_rest/response'
require 'eac_ruby_utils/core_ext'
require 'faraday'

module EacRest
  class Request
    BOOLEAN_MODIFIERS = %w[ssl_verify].freeze
    COMMON_MODIFIERS = %w[auth body_data verb].freeze
    HASH_MODIFIERS = %w[header].freeze
    MODIFIERS = COMMON_MODIFIERS + BOOLEAN_MODIFIERS + HASH_MODIFIERS.map(&:pluralize)

    enable_immutable
    immutable_accessor(*BOOLEAN_MODIFIERS, type: :boolean)
    immutable_accessor(*COMMON_MODIFIERS, type: :common)
    immutable_accessor(*HASH_MODIFIERS, type: :hash)

    enable_listable
    lists.add_symbol :verb, :get, :delete, :options, :post, :put

    common_constructor :url, :body_data_proc, default: [nil]

    def autenticate(username, password)
      auth(::Struct.new(:username, :password).new(username, password))
    end

    # @return [Faraday::Connection]
    def faraday_connection
      ::Faraday.default_connection_options[:headers] = {}
      ::Faraday::Connection.new(faraday_connection_options) do |conn|
        conn.request :url_encoded
        auth.if_present { |v| conn.request :authorization, :basic, v.username, v.password }
      end
    end

    # @return [Hash]
    def faraday_connection_options
      {
        request: { params_encoder: Faraday::FlatParamsEncoder }, ssl: { verify: ssl_verify? }
      }
    end

    # @return [Faraday::Response]
    def faraday_response
      conn = faraday_connection
      conn.send(sanitized_verb, url) do |req|
        req.headers = conn.headers.merge(headers)
        sanitized_body_data.if_present { |v| req.body = v }
      end
    end

    def immutable_constructor_args
      [url, body_data_proc]
    end

    def response
      ::EacRest::Response.new(self)
    end

    # @return [Symbol]
    def sanitized_verb
      verb.if_present(VERB_GET) { |v| self.class.lists.verb.value_validate!(v) }
    end

    private

    def body_fields
      @body_fields ||= ::EacRest::Request::BodyFields.new(body_data)
    end

    def sanitized_body_data
      body_fields.to_h || body_data
    end

    require_sub __FILE__
  end
end
