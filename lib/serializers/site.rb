require 'serializers/geo'
require 'serializers/address'

class SiteSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/sites/#{item.uprn}"
    type "Site"

    map_properties :uprn, :usrn

    entity :geo, item, GeoSerializer
    entity :address, item.address, AddressSerializer
  end

end
