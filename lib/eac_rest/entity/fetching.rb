# frozen_string_literal: true

require 'eac_rest/helper'
require 'eac_ruby_utils/core_ext'

module EacRest
  class Entity
    module Fetching
      # @return [Addressable::URI]
      def entity_root_url_suffix
        parent_entity.if_present('', &:entity_root_url_suffix).to_uri
      end

      # @return [EacRest::Request]
      def request(url_suffix)
        api.request(::EacRest::Helper.url_join(entity_root_url_suffix, url_suffix))
      end
    end
  end
end
