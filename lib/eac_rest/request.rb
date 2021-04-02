# frozen_string_literal: true

require 'eac_rest/response'
require 'eac_ruby_utils/core_ext'
require 'ostruct'

module EacRest
  class Request
    MODIFIERS = %w[auth].freeze
    common_constructor :url, :body_data_proc, default: [nil]

    def autenticate(username, password)
      self.auth = ::OpenStruct.new(username: username, password: password)
    end

    def header(name, value)
      headers[name.to_s] = value
    end

    def response
      ::EacRest::Response.new(build_curl, body_data_proc)
    end

    private

    attr_accessor :auth

    def build_curl
      r = ::Curl::Easy.new(url)
      MODIFIERS.each { |suffix| send("build_curl_#{suffix}", r) }
      r.headers.merge!(headers)
      r
    end

    def build_curl_auth(curl)
      auth.if_present do |a|
        curl.http_auth_types = :basic
        curl.username = a.username
        curl.password = a.password
      end
    end

    def headers
      @headers ||= {}
    end
  end
end
