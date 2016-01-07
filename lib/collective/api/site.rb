module Collective::Api
  class Site < Base
    
    def self.all(args = {})
      Base.process_params(args)
      data = Collective::Premise.premises_get(args)
      sites = []
      if data[:@record_count].to_i > 0
        sites = data[:premises].map do |p|
          Site.new(p)
        end
      end
      sites
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

