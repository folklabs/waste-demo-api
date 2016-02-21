class CaseTypeSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/case-types/#{item.id}"
    type "CaseType"

    map_properties :id, :name, :description
  end

end
