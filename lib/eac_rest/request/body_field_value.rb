# frozen_string_literal: true

require 'eac_fs/file_info'
require 'eac_ruby_utils/core_ext'
require 'faraday'
require 'faraday/multipart'

module EacRest
  class Request
    class BodyFieldValue
      common_constructor :value

      def to_faraday
        return value unless file?

        ::Faraday::Multipart::FilePart.new(value, file_mime_type)
      end

      # @return [Boolean]
      def file?
        value.is_a?(::File)
      end

      # @return [String]
      def file_mime_type
        ::EacFs::FileInfo.new(value.path).mime_type
      end
    end
  end
end
