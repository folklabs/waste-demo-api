require 'oat/adapters/hal'
class CollectionSerializer < Oat::Serializer
  adapter Oat::Adapters::HAL

  schema do
    type "Collection"
    collection :tasks, item, TaskSerializer
    # properties do |props|
    #   props.id item.id
    #   # props.price item.price
    #   # props.description item.blurb
    # end
  end

end