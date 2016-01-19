class GeoSerializer < Oat::Serializer

  schema do
    type "Geo"

    map_properties :latitude, :longitude
  end

end
