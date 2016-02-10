module WasteSystem
  class Base
    
    def self.map_method(name, from_name = nil)
      from_name = name if from_name == nil
      define_method(name) do
        @json[:"#{from_name}"]
      end
    end

    def self.create_api_objects(data, clazz, json_key)
      items = []
      if data[:@record_count].to_i == 1
        # Single object is given if just one, otherwise its a list
        items = [clazz.new(data[json_key])]
      elsif data[:@record_count].to_i > 1
        data = data[json_key]
        data = data.values[0] if data.class == Hash
        items = data.map do |p|
          clazz.new(p)
        end
      end
      items
    end

    def self.get_related_content(args, clazz)
      items = []
      if args[:include]
        if args[:include].split(',').include?('related')
          site_class = Session.get.resource_class("/sites")
          site = site_class.find(args[:uprn])
          if site.parent_uprn
            items = clazz.all(uprn: site.parent_uprn)
          end
        end
      end
      items
    end

  end
end