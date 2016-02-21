require 'waste_system'

module Collective
  class Address < Base
    include WasteSystem::Address

    map_method 'paon', 'address2'
    map_method 'saon', 'address1'
    map_method 'street'
    map_method 'locality'
    map_method 'town'
    map_method 'county'
    map_method 'postcode', 'post_code'
  end
end

