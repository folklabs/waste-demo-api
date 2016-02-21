module Collective
  class Case < Base

    map_method 'id'
    map_method 'title', 'service_code'
    # map_method 'description'

    def self.all(args = {})
      Base.process_params(args)
      
      # data = Collective::Base.service_requests_types_get(args)
      # puts data
      args[:RequestDate] = { MinimumDate: "1970-01-01", MaximumDate: "2070-01-01" }
      args[:SLABreachTime] = { MinimumDate: "1970-01-01", MaximumDate: "2070-01-01" }
      data = self.service_requests_get(args)
      puts data
      objects = create_api_objects(data, Collective::Case, :service_request)
    end

    # TODO: improve when its possible to query a single item
    def self.find(id)
      # features_types = self.all
      # matched = features_types.select {|t| t.id == id }
      # matched[0] if matched.size > 0
    end

    def status
      @json[:service_status][:status].downcase if @json[:service_status]
    end

    def location
      Site.new(@json[:premises])
    end

    def case_type
      CaseType.new(@json[:service_type])
    end

  end
end

