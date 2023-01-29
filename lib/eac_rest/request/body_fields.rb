# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_rest/request/body_field'

module EacRest
  class Request
    class BodyFields
      common_constructor :source_body

      # @return [Hash, nil]
      def to_h
        fields.if_present do |v|
          v.each_with_object({}) { |e, a| a[e.hash_key] = e.hash_value }
        end
      end

      # @return [Array<EacRest::Request::BodyField>, nil]
      def fields
        source_body.if_present do |v|
          next nil unless v.is_a?(::Enumerable)

          if v.is_a?(::Hash)
            ::EacRest::Request::BodyField.list_from_hash(v)
          else
            ::EacRest::Request::BodyField.list_from_enumerable(v)
          end
        end
      end
    end
  end
end
