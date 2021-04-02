# frozen_string_literal: true

require 'eac_rest/response'
require 'eac_ruby_utils/core_ext'
require 'ostruct'

module EacRest
  class Request
    COMMON_MODIFIERS = %w[auth].freeze
    HASH_MODIFIERS = %w[header].freeze
    MODIFIERS = COMMON_MODIFIERS + HASH_MODIFIERS.map(&:pluralize)

    enable_immutable
    immutable_accessor(*COMMON_MODIFIERS, type: :common)
    immutable_accessor(*HASH_MODIFIERS, type: :hash)

    common_constructor :url, :body_data_proc, default: [nil]

    def autenticate(username, password)
      auth(::OpenStruct.new(username: username, password: password))
    end

    def immutable_constructor_args
      [url, body_data_proc]
    end

    def response
      ::EacRest::Response.new(build_curl, body_data_proc)
    end

    private

    def build_curl
      r = ::Curl::Easy.new(url)
      MODIFIERS.each { |suffix| send("build_curl_#{suffix}", r) }
      r
    end

    def build_curl_auth(curl)
      auth.if_present do |a|
        curl.http_auth_types = :basic
        curl.username = a.username
        curl.password = a.password
      end
    end

    def build_curl_headers(curl)
      curl.headers.merge!(headers)
    end
  end
end
