require 'waste_system'

module Collective
  class Address < Base
    include WasteSystem::Address

    def paon
      @json[:address2]
    end

    def saon
      @json[:address1]
    end

    def street
      @json[:street]
    end

    def locality
      @json[:locality]
    end

    def town
      @json[:town]
    end

    def postcode
      @json[:post_code]
    end

  end
end

