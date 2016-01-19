class WasteEventSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/events/#{item.id}"
    type "WasteEvent"

    map_properties :id, :event_type, :start_date, :task_id
    property :location, "#{context[:request].base_url}/sites/#{item.location.uprn}"
  end

end
