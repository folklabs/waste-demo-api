class CaseSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/cases/#{item.id}"
    type "Case"

    map_properties :id, :title, :status

    property :site, "#{context[:request].base_url}/sites/#{item.location.uprn}"

    entity :case_type, item.case_type, CaseTypeSerializer
  end

end
