# require 'oat/adapters/hal'
# require 'oat/adapters/siren'
class WasteServiceSerializer < Oat::Serializer
  # adapter Oat::Adapters::HAL

  schema do
    type "WasteService"
    link :self, href: "#{context[:request].base_url}/services/#{item.id}"

    map_properties :id, :name, :esd_url

    entities :feature_types, item.feature_types do |feature_type, serializer|
      serializer.properties do |props|
        props.name feature_type.name
        props.description feature_type.description
      end
    end
  end

end
