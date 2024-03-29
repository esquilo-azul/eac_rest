# frozen_string_literal: true

require 'eac_rest/helper'
require 'eac_rest/request'
require 'eac_ruby_utils/core_ext'

module EacRest
  # Abstract methods
  #   * self.issue_get_url_suffix(provider_issue_id)
  class Api
    DEFAULT_ROOT_ENTITY_CLASS_NAME_SUFFIX = 'Root'
    JSON_REQUEST_HEADERS = { 'Accept' => 'application/json' }.freeze

    require_sub __FILE__, include_modules: true
    attr_accessor :ssl_verify

    common_constructor :root_url, :username, :password, default: [nil, nil] do
      self.ssl_verify = true
    end

    # @param entity_class [Class]
    # @param url_suffix [String]
    # @return [EacRest::Entity]
    def entity(entity_class, data_or_id, options = {})
      entity_class.new(self, data_or_id, options)
    end

    def request(service_url_suffix, headers = {}, &body_data_proc)
      r = ::EacRest::Request.new(build_service_url(service_url_suffix),
                                 body_data_proc).ssl_verify(ssl_verify)
      headers.each { |name, value| r = r.header(name, value) }
      r = r.autenticate(username, password) if username.present?
      r
    end

    def request_json(service_url_suffix, headers = {}, &body_data_proc)
      request(service_url_suffix, headers.merge(JSON_REQUEST_HEADERS)) do |body_data|
        r = body_data.is_a?(::Enumerable) ? body_data : ::JSON.parse(body_data)
        r = body_data_proc.call(r) if body_data_proc
        r
      end
    end

    # @return [Addressable::URI]
    def build_service_url(suffix)
      ::EacRest::Helper.url_join(root_url, suffix)
    end

    # @return [EacRest::Entity]
    def root_entity
      @root_entity ||= root_entity_class.new(self, nil)
    end

    # @return [Class]
    def root_entity_class
      self.class.const_get(DEFAULT_ROOT_ENTITY_CLASS_NAME_SUFFIX)
    end
  end
end
