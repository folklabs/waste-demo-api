module Collective::Api
  class Base
    PARAMS_MAP = {
        'postcode': :'Postcode',
        'uprn': :'UPRN',
        'usrn': :'USRN',
        'include_related': :'IncludeRelated',
      }
    
    attr_accessor :type

    def initialize(json)
      @json = json
      @type = self.class.name
    end

    def self.map_method(name, from_name = nil)
      from_name = name if from_name == nil
      define_method(name) do
        @json[:"#{from_name}"]
      end
    end

    def extract_data(data, property)
      if data[:@record_count].to_i > 0
        data[property]
      end
    end

    # Adjusts HTTP parameters from lowercase REST API format to whatever 
    # Collective requires.
    def self.process_params(params)
      PARAMS_MAP.each_pair do |key, value|
        if params[key] or params[key.to_sym]
          params[value] = params[key]
          params.delete(key)
        end
      end
      if params['date_range']
        dates = params['date_range'].split(',')
        params.delete('date_range')
        params[:DateRange] = { MinimumDate: dates[0], MaximumDate: dates[1] }
      end
    end

    def self.create_api_objects(data, clazz, json_key)
      if data[:@record_count].to_i == 1
        # Single object is given if just one, otherwise its a list
        items = [clazz.new(data[json_key])]
      elsif data[:@record_count].to_i > 1
        data = data[json_key]
        data = data.values[0] if data.class == Hash
        items = data.map do |p|
          clazz.new(p)
        end
      else
        items = []
      end
    end
  end
end