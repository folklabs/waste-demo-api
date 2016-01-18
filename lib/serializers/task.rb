require 'oat/adapters/hal'
class TaskSerializer < Oat::Serializer
  adapter Oat::Adapters::HAL

  schema do
    type "Task"
    # link :self, href: product_url(item)

    properties do |props|
      props.id item.id
      # props.price item.price
      # props.description item.blurb
    end

    if params.has_key?('show_events')
      entities :events, item.events do |event, s|
        s.name event.name
        s.id event.id
      end
    end
  end

end