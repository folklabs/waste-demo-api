module Collective
  class Case < Base

    map_method 'id'
    map_method 'name'
    map_method 'description'

    def self.all(args = {})
      Base.process_params(args)
      
      data = Collective::Base.service_requests_types_get(args)
      puts data
      data = Collective::Base.service_requests_get(args)
      puts data
      # objects = create_api_objects(data, Collective::FeatureType, :feature_type)
    end

    # TODO: improve when its possible to query a single item
    def self.find(id)
      features_types = self.all
      matched = features_types.select {|t| t.id == id }
      matched[0] if matched.size > 0
    end

  end
end

