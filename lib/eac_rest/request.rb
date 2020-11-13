# frozen_string_literal: true

require 'eac_rest/response'
require 'eac_ruby_utils/core_ext'
require 'ostruct'

module EacRest
  class Request
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
      auth.if_present do |a|
        r.http_auth_types = :basic
        r.username = a.username
        r.password = a.password
      end
      r.headers.merge!(headers)
      r
    end

    def headers
      @headers ||= {}
    end
  end
end
