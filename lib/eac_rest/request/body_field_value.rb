# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRest
  class Request
    class BodyFieldValue
      common_constructor :value

      def to_faraday
        value
      end
    end
  end
end
