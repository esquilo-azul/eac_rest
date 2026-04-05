# frozen_string_literal: true

module EacRest
  class Entity
    module Fetching
      # @param url_suffix [Addressable::URI]
      # @return [EacRest::Request]
      def request(url_suffix)
        request_json(url_suffix)
      end

      # @param url_suffix [Addressable::URI]
      # @return [EacRest::Request]
      def request_json(url_suffix = '')
        api.request_json(to_api_address_suffix(url_suffix))
      end

      # @return [String]
      def to_api_address_suffix(url_suffix = '')
        r = [to_api_address_suffix_self, url_suffix].join
        r = parent_entity.to_api_address_suffix(r) if parent_entity
        r
      end

      # @return [String]
      def to_api_address_suffix_self
        raise_abstract_method __method__
      end
    end
  end
end
