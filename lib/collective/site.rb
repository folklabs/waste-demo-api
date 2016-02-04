module Collective
  class Site < Base
    
    def self.all(args = {})
      Base.process_params(args)
      data = self.premises_get(args)
      sites = []
      if data[:@record_count].to_i > 0
        sites = data[:premises].map do |p|
          Site.new(p)
        end
      end
      sites
    end

    def self.find(uprn_val)
      data = self.premises_get({UPRN: uprn_val})
      # TODO: data available?
      Site.new(data[:premises])
    end

    def uprn
      @json[:uprn].to_i
    end

    def usrn
      @json[:usrn].to_i
    end

    def parent_uprn
      @json[:parent_uprn].to_i if @json[:parent_uprn]
    end

    def latitude
      @json[:location][:metric][:@latitude]
    end

    def longitude
      @json[:location][:metric][:@longitude]
    end

    def address
      Collective::Address.new(@json[:address]) if @json[:address]
    end

    def attributes
      if @attributes == nil
        data = self.premises_attributes_get(uprn)
        data = extract_data(data, :attributes)
      end
    end

    def to_s
      "#{uprn}: #{address.to_s}"
    end

  end
end

