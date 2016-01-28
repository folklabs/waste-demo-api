module Collective::Api
  class FeatureType < Base

    map_method 'id'
    map_method 'name'
    map_method 'description'

    def self.all(args = {})
      Base.process_params(args)
      
      data = Collective::Base.features_types_get(args)
      features_types = create_api_objects(data, Collective::Api::FeatureType, :feature_type)
    end

    # TODO: improve when its possible to query a single item
    def self.find(id)
      features_types = self.all
      matched = features_types.select {|t| t.id == id }
      matched[0] if matched.size > 0
    end

    def category_name
      @json[:feature_class][:feature_category][:name]
    end
  end
end

