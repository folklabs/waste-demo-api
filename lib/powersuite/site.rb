module Powersuite
  class Site < Base
    
    def self.all(args = {})
      Base.process_params(args)
      args[:_wrapper] = :sitesInput
      data = self.get_sites(args)
      sites = []
      unless data[:site_array] == nil
        #TODO: check for multiple
        # sites = data[:site_array].map do |p|
        sites << Site.new(data[:site_array][:account_site])
        # end
      end
      sites
    end

    def self.find(uprn_val)
      data = self.get_site_info(Uprn: uprn_val, _wrapper: :siteInfoInput)
      # TODO: data available?
      Site.new(data[:site])
    end

    def uprn
      @json[:account_site_uprn].to_i
    end

    def usrn
      # @json[:usrn].to_i
      nil
    end

    def latitude
      @json[:site][:site_latitude]
    end

    def longitude
      @json[:site][:site_longitude]
    end

    def address
      Address.new(@json[:address]) if @json[:address] != nil
    end

    def parent_uprn
      @json[:site][:site_parent_id] if @json[:site]
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

