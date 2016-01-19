module Collective::Api
  class Base
    PARAMS_MAP = {
        'postcode': 'Postcode',
        'uprn': 'UPRN',
        'usrn': 'USRN',
      }

    def initialize(json)
      @json = json
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
        if params[key]
          params[value] = params[key]
          params.delete(key)
        end
      end
      if params['date_range']
        dates = params['date_range'].split(',')
        params.delete('date_range')
        params[:DateRange] = {MinimumDate: dates[0], MaximumDate: dates[1]}
      end
    end

    def self.create_api_objects(data, clazz, json_type)
      if data[:@record_count].to_i == 1
        # Single object is given if just one, otherwise its a list
        events = [clazz.new(data[json_type])]
      elsif data[:@record_count].to_i > 1
        events = data[json_type].map do |p|
          clazz.new(p)
        end
      else
        events = []
      end
    end
  end
end