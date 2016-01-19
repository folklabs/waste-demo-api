class TaskSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/tasks/#{item.id}"
    #TODO: in future this would need to change depending on task type
    type "EmptyBinTask"

    map_properties :id

    if context[:request]['show_events'] != nil
      entities :events, item.events do |event, s|
        s.name event.name
        s.id event.id
      end
    end
  end

end
