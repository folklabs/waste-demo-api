module Collective::Api
  class Site < Base
    def self.all(args = {})
      # TODO: consider generic capitalization approach
      if args[:postcode]
        args[:Postcode] = args[:postcode]
        args.delete(:postcode)
      end
      data = Collective::Premise.premises_get(args)
      puts data
      puts data.count
      sites = []
      puts data[:errors][:@record_count].to_i
      puts data[:errors]
      if data[:@record_count].to_i > 0
        sites = data[:premises].map do |p|
          puts p[:uprn]
          Site.new(p)
          # puts data
        end
      end
      sites
      # puts data
      # Place.new(data[:premises])
    end

    def self.find(uprn_val)
      data = Collective::Premise.premises_get({UPRN: uprn_val})
      # TODO: data available?
      Site.new(data[:premises])
    end

    def uprn
      @json[:uprn].to_i
    end

    def usrn
      @json[:usrn].to_i
    end

    def latitude
      @json[:location][:metric][:@latitude]
    end

    def longitude
      @json[:location][:metric][:@longitude]
    end

    def address
      Address.new(@json[:address]) if @json[:address] != nil
    end

    def attributes
      if @attributes == nil
        data = Collective::Premise.premises_attributes_get(uprn)
        data = extract_data(data, :attributes)
      end
    end

    def to_s
      "#{uprn}: #{address.to_s}"
    end

  end
end

