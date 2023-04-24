# frozen_string_literal: true

require 'eac_envs/http/request'
require 'eac_rest/response'
require 'eac_ruby_utils/core_ext'

module EacRest
  class Request
    attr_reader :internal_request

    # @param url [EacEnvs::Http::Request, String]
    # @param response_body_data_proc [Proc, nil]
    def initialize(url, response_body_data_proc = nil)
      if url.is_a?(::EacEnvs::Http::Request)
        @internal_request = url
      else
        @internal_request = ::EacEnvs::Http::Request.new.url(url)
        response_body_data_proc.if_present do |v|
          @internal_request = @internal_request.response_body_data_proc(v)
        end
      end
    end

    delegate :sanitized_verb, :url, to: :internal_request

    {
      auth: 0, body_data: 0, header: 1, headers: 0, ssl_verify: 0, verb: 0
    }.each do |method_name, read_args_count|
      define_method method_name do |*args|
        if args.count <= read_args_count
          internal_request.send(method_name, *args)
        else
          self.class.new(internal_request.send(method_name, *args))
        end
      end
    end

    # @return [EacRest::Request]
    def autenticate(username, password)
      self.class.new(internal_request.basic_auth(username, password))
    end

    # @return [EacRest::Response]
    def response
      ::EacRest::Response.new(self)
    end
  end
end
