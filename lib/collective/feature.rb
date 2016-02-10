module Collective
  class Feature < Base
    # extend WasteSystem::RelatedContent

    map_method 'id'
    map_method 'name'
    map_method 'description'
    map_method 'uprn'

    def self.all(args = {})
      Base.process_params(args)
      args[:'Types/'] = '' if args[:Types] == nil
      args[:'Statuses/'] = '' if args[:Statuses] == nil
      args[:'Statuses/'] = '' if args[:Statuses] == nil
      args[:'Manufacturers/'] = '' if args[:Manufacturers] == nil
      args[:'Colours/'] = '' if args[:Colours] == nil
      args[:'Conditions/'] = '' if args[:Conditions] == nil
      args[:'WasteTypes/'] = '' if args[:WasteTypes] == nil
      data = Collective::Base.features_get(args)
      features = create_api_objects(data, self, :feature)
      features += Feature.get_related_content(args, Feature)
    end

    # TODO: improve when its possible to query a single item
    def self.find(id)
      items = self.all
      matched = items.select {|t| t.id == id }
      matched[0] if matched.size > 0
    end

    def category_name
      @json[:feature_class][:feature_category][:name]
    end
  end
end

