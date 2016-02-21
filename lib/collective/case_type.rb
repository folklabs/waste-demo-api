module Collective
  class CaseType < Base

    map_method 'id'
    map_method 'name'
    map_method 'description'

    def self.all(args = {})
      Base.process_params(args)
      data = self.service_requests_types_get(args)
      objects = create_api_objects(data, Collective::CaseType, :service_type)
    end

    # TODO: improve when its possible to query a single item
    def self.find(id)
      # features_types = self.all
      # matched = features_types.select {|t| t.id == id }
      # matched[0] if matched.size > 0
    end

    # def status
    #   @json[:service_status][:status].downcase if @json[:service_status]
    # end

    # def location
    #   Site.new(@json[:premises])
    # end

  end
end

