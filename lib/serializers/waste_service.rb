class WasteServiceSerializer < Oat::Serializer

  schema do
    type "WasteService"
    link :self, href: "#{context[:request].base_url}/services/#{item.id}"

    map_properties :id, :name, :description, :frequency

    if item.respond_to?(:esd_url)
      map_properties :esd_url
    end

    entities :feature_types, item.feature_types do |feature_type, serializer|
      serializer.type "FeatureType"
      serializer.properties do |props|
        props.name feature_type.name
        props.description feature_type.description
      end
    end

    tasks = context[:tasks]
    if tasks
      last_tasks = []
      next_tasks = []
      now = DateTime.now.to_date
      tasks.each do |task|
        next unless item.task_matches(task)
        start = task.start_date.to_date
        if start < now
          last_tasks << task
        else
          next_tasks << task
        end
      end
      entities :last_collections, last_tasks, TaskSerializer
      entities :next_collections, next_tasks, TaskSerializer
    end
  end

end
