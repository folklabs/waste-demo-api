class WasteServiceCollectionSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/services"
    type "Collection"
    collection :waste_services, item, WasteServiceSerializer
    # properties do |props|
    #   props.id item.id
    #   # props.price item.price
    #   # props.description item.blurb
    # end
  end

end