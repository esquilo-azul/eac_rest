# frozen_string_literal: true

require 'curb'
require 'eac_rest/response'
require 'eac_ruby_utils/core_ext'

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

    def build_curl
      r = ::Curl::Easy.new(url)
      MODIFIERS.each { |suffix| send("build_curl_#{suffix}", r) }
      r
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

    def build_curl_auth(curl)
      auth.if_present do |a|
        curl.http_auth_types = :basic
        curl.username = a.username
        curl.password = a.password
      end
    end

    def build_curl_body_data(curl)
      sanitized_body_data.if_present { |v| curl.post_body = v }
    end

    def build_curl_headers(curl)
      curl.headers.merge!(headers)
    end

    def build_curl_ssl_verify(curl)
      return if ssl_verify?.nil?

      curl.ssl_verify_host = ssl_verify?
      curl.ssl_verify_peer = ssl_verify?
    end

    def build_curl_verb(curl)
      curl.set(:customrequest, sanitized_verb.to_s.upcase)
    end

    def sanitized_body_data
      body_data.if_present do |v|
        v = v.map { |k, vv| [k, vv] } if v.is_a?(::Hash)
        v = URI.encode_www_form(v) if v.is_a?(::Array)
        v.to_s
      end
    end
  end
end
