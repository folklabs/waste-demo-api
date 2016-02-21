class AddressSerializer < Oat::Serializer

  schema do
    type "Address"

    map_properties :paon, :saon, :street, :locality, :town, :county, :postcode, :description
  end

end
