# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRest
  class Request
    class BodyFields
      common_constructor :source_body

      # @return [Hash, nil]
      def to_h
        source_body.if_present do |v|
          next nil unless v.is_a?(::Enumerable)
          next v if v.is_a?(::Hash)

          v.each_with_object({}) do |e, a|
            a[e[0]] ||= []
            a[e[0]] << e[1]
          end
        end
      end
    end
  end
end
