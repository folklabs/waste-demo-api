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
        'include': :'IncludeRelated',
      }
    
    attr_accessor :type

    def initialize(json)
      @json = json
      @type = self.class.name
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

    def extract_data(data, property)
      if data[:@record_count].to_i > 0
        data[property]
      end
    end

    # Adjusts HTTP parameters from lowercase REST API format to whatever 
    # Collective requires.
    def self.process_params(params)
      halt 400 if params['include'] && params['include'] != 'related'

      PARAMS_MAP.each_pair do |key, value|
        convert_argument(params, key, value)
      end
      if params['start_date'] || params['end_date']
        start_date  = params['start_date'] || date_now
        end_date  = params['end_date'] || date_now
        halt 400 if start_date.to_i > end_date.to_i

        params.delete('start_date')
        params.delete('end_date')
        params[:DateRange] = { MinimumDate: start_date, MaximumDate: end_date }
      end
    end

    def self.convert_argument(params, arg_in, arg_out)
      if params[arg_in] or params[arg_in.to_sym]
        params[arg_out] = params[arg_in]
        params.delete(arg_in)
        params.delete(arg_in.to_s)
      end
    end

    def self.date_now
      DateTime.now.to_date.to_s
    end

  end
end

