class CollectionSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/#{context[:name]}"
    type "Collection"
    
    collection context[:name], item, context[:serializer]
  end

end
