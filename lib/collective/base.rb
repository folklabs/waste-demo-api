require 'waste_system'

module Collective
  class Base < WasteSystem::Base

    def self.method_missing(m, *args, &block)  
      session = Collective::Session.new
      args = {} if args.size == 0
      args = args[0] if args.size == 1
      result = session.call(:"#{m}", args)
      result
    end  

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

    # def self.map_method(name, from_name = nil)
    #   from_name = name if from_name == nil
    #   define_method(name) do
    #     @json[:"#{from_name}"]
    #   end
    # end

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

  end
end

