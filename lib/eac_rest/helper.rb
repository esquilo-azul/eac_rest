# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRest
  module Helper
    # @param parts [Array<Addressable::URI>]
    # @return [Addressable::URI]
    def url_join(*parts)
      left = parts.shift
      left = url_join_pair(left, parts.shift) while parts.any?
      left
    end

    private

    # @param left [Addressable::URI]
    # @param right [Addressable::URI]
    # @return [Addressable::URI]
    def url_join_pair(left, right)
      r = ::Addressable::URI.parse(right)
      return r if r.scheme.present?

      s = ::Addressable::URI.parse(right)
      r = ::Addressable::URI.parse(left)
      r.path += s.path
      r.query_values = r.query_values(::Array).if_present([]) +
                       s.query_values(::Array).if_present([])
      r
    end

    extend self
  end
end
