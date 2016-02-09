module Powersuite
  class Base < WasteSystem::Base
    PARAMS_MAP = {
      'postcode': :'Postcode',
      'uprn': :'Uprn',
      'usrn': :'Usrn',
      'include_related': :'IncludeRelated',
      'start_date': :'NextCollectionFromDate'
    }

    def initialize(json)
      @json = json
      @type = self.class.name
    end

    def self.method_missing(m, *args, &block)  
      session = Powersuite::Session.new
      args = {} if args.size == 0
      args = args[0] if args.size == 1
      result = session.call(:"#{m}", args)
      result
    end  

    # Adjusts HTTP parameters from lowercase REST API format to whatever 
    # Collective requires.
    def self.process_params(params)
      PARAMS_MAP.each_pair do |key, value|
        if params[key] or params[key.to_sym]
          params[value] = params[key]
          params.delete(key)
          params.delete(key.to_s)
        end
      end
      if params['date_range']
        dates = params['date_range'].split(',')
        params.delete('date_range')
        params[:DateRange] = { MinimumDate: dates[0], MaximumDate: dates[1] }
      end
    end
    
    # def to_s
    #   self.class
    # end

    # def to_ary
    #   [self.class]
    # end
  end
end

