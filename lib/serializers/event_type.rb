class EventTypeSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/event-types/#{item.id}"
    type item.type

    map_properties :id, :name
  end

end
