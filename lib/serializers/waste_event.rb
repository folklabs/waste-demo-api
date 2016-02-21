class WasteEventSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/events/#{item.id}"
    type "WasteEvent"

    map_properties :id, :start_date, :description
    map_properties :event_type if item.event_type
    map_properties :task_id if item.task_id
    property :location, "#{context[:request].base_url}/sites/#{item.location.uprn}"
  end

end
