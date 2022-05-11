# frozen_string_literal: true

require 'active_support/core_ext/hash/conversions'
require 'eac_ruby_utils/core_ext'
require 'json'

module EacRest
  class Response < ::StandardError
    HEADER_LINE_PARSER = /\A([^:]+):(.*)\z/.to_parser do |m|
      [m[1].strip, m[2].strip]
    end

    common_constructor :curl, :body_data_proc

    def body_data
      r = performed_curl.headers['Accept'].if_present(body_str) do |v|
        method_name = "body_data_from_#{v.parameterize.underscore}"
        respond_to?(method_name) ? send(method_name) : body_str
      end
      r = body_data_proc.call(r) if body_data_proc.present?
      r
    end

    def body_data_or_raise
      raise_unless_200

      body_data
    end

    delegate :body_str, to: :performed_curl

    def body_str_or_raise
      raise_unless_200

      body_str
    end

    def headers
      performed_curl.header_str.each_line.map(&:strip)[1..-1].reject(&:blank?)
                    .map { |header_line| HEADER_LINE_PARSER.parse!(header_line) }
                    .to_h
    end

    def raise_unless_200
      return nil if status == 200

      raise self
    end

    def status
      performed_curl.status.to_i
    end

    delegate :url, to: :curl

    def to_s
      "URL: #{url}\nStatus: #{status}\nBody:\n\n#{body_str}"
    end

    private

    def body_data_from_application_json
      ::JSON.parse(body_str)
    end

    def body_data_from_application_xml
      Hash.from_xml(body_str)
    end

    def perform
      @perform ||= begin
        curl.perform || raise("CURL perform failed for #{url}")
        true
      end
    end

    def performed_curl
      perform
      curl
    end
  end
end
