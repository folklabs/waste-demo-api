module Powersuite
  class Service < Base

    map_method 'id', 'service_id'
    map_method 'name', 'service_name'
    map_method 'description', 'service_description'
    map_method 'frequency'

    def self.all(args = {})
      Base.process_params(args)
      args[:_wrapper] = :serviceInput
      data = self.get_services(args)
      services = []
      unless data[:services] == nil
        #TODO: check for multiple
        services = data[:services][:service].map do |p|
          Service.new(p)
        end
      end
      services
    end

    def feature_types
      args = { ServiceId: id, _wrapper: :serviceItemInput }
      data = Service.get_service_items(args)
      feature_types = []
      if data[:error_code] == "0"
        feature_types = data[:service_items][:service_item].map do |ft|
          FeatureType.new(ft)
        end
      end
      feature_types
    end

    def task_matches(task)
      return task.name == name
    end

  end
end

