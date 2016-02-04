require 'waste_system'

module Collective
  class Address < Base
    include WasteSystem::Address

    def paon
      @json[:site_address2]
    end

    def saon
      @json[:site_address1]
    end

    def street
      @json[:site_street]
    end

    def locality
      nil
    end

    def town
      @json[:site_town]
    end

    def postcode
      @json[:site_post_code]
    end

  end
end

