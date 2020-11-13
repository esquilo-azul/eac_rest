# frozen_string_literal: true

require 'eac_rest/request'
require 'eac_ruby_utils/core_ext'

module EacRest
  # Abstract methods
  #   * self.issue_get_url_suffix(provider_issue_id)
  class Api
    require_sub __FILE__, include_modules: true
    common_constructor :root_url, :username, :password, default: [nil, nil]

    def request(service_url_suffix, headers = {}, &body_data_proc)
      r = ::EacRest::Request.new(build_service_url(service_url_suffix),
                                 body_data_proc)
      headers.each { |name, value| r.header(name, value) }
      r.autenticate(username, password) if username.present?
      r
    end

    def request_json(service_url_suffix, headers = {}, &body_data_proc)
      request(service_url_suffix, headers.merge('Accept' => 'application/json'), &body_data_proc)
    end

    def build_service_url(suffix)
      s = ::Addressable::URI.parse(suffix)
      r = ::Addressable::URI.parse(root_url)
      r.path += s.path
      r.query_values = r.query_values.if_present({}).merge(s.query_values.if_present({}))
      r.to_s
    end
  end
end
