class TaskSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/tasks/#{item.id}"
    #TODO: in future this would need to change depending on task type
    type "EmptyBinTask"

    map_properties :id, :name, :start_date

    property :site, "#{context[:request].base_url}/sites/#{item.location.uprn}"

    if context[:request]['show_events'] != nil
      entities :events, item.events do |event, s|
        s.name event.name
        s.id event.id
      end
    end
  end

end
