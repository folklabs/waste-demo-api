class WasteServiceSerializer < Oat::Serializer

  schema do
    type "WasteService"
    link :self, href: "#{context[:request].base_url}/services/#{item.id}"

    map_properties :id, :name, :esd_url

    entities :feature_types, item.feature_types do |feature_type, serializer|
      serializer.type "FeatureType"
      serializer.properties do |props|
        props.name feature_type.name
        props.description feature_type.description
      end
    end
  end

end
