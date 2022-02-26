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
      headers.each { |name, value| r = r.header(name, value) }
      r = r.autenticate(username, password) if username.present?
      r
    end

    def request_json(service_url_suffix, headers = {}, &body_data_proc)
      request(service_url_suffix, headers.merge('Accept' => 'application/json')) do |body_data|
        r = ::JSON.parse(body_data)
        r = body_data_proc.call(r) if body_data_proc
        r
      end
    end

    # @return [Addressable::URI]
    def build_service_url(suffix)
      s = ::Addressable::URI.parse(suffix)
      r = ::Addressable::URI.parse(root_url)
      r.path += s.path
      r.query_values = r.query_values(::Array).if_present([]) +
                       s.query_values(::Array).if_present([])
      r
    end
  end
end
