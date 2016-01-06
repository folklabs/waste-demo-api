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
      # puts 'map_method'
      from_name = name if from_name == nil
      define_method(name) do
        # puts name
        # puts JSON.pretty_generate(@json)
        # puts @json
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
    end
  end
end