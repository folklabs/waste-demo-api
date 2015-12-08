module Collective::Api
  class Base
    def initialize(json)
      @json = json
      # puts json
    end
    
    # def method_missing(m, *args, &block)  
    #   puts 'method_missing'
    #   session = Collective::Session.instance
    #   args = {} if args.size == 0
    #   args = args[0] if args.size == 1
    #   session.call(:"#{m}", args)
    # end  

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
  end
end