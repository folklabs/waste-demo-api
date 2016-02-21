require 'waste_system'

module Powersuite
  class Address < Base
    include WasteSystem::Address

    def paon
      @json[:site_address_number]
    end

    def saon
      @json[:site_address1]
    end

    def street
      @json[:site_address2]
    end

    def locality
      nil
    end

    def town
      @json[:site_town] || @json[:site_city]
    end

    def county
      @json[:site_county]
    end

    def postcode
      @json[:site_post_code]
    end

  end
end

