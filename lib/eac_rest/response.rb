# frozen_string_literal: true

require 'eac_rest/error'
require 'eac_envs/http/error'
require 'eac_ruby_utils/core_ext'

module EacRest
  class Response < ::StandardError
    common_constructor :request
    delegate :body_data_proc, to: :request

    def internal_response
      @internal_response ||= request.internal_request.response
    end

    %i[body_data body_data_or_raise body_str body_str_or_raise header headers
       link links raise_unless_200 status to_s url].each do |method_name|
      define_method method_name do |*args, &block|
        internal_response.send(method_name, *args, &block)
      rescue ::EacEnvs::Http::Error
        raise ::EacRest::Error
      rescue ::EacEnvs::Http::Response
        raise self
      end
    end
  end
end
