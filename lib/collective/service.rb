module Collective
  class Service < Base

    map_method 'id'
    map_method 'name'
    map_method 'description'
    map_method 'frequency'
    map_method 'esd_url'
    map_method 'feature_types'

    def task_matches(task)
      @json[:feature_types].each do |ft|
        return true if task.name.downcase.include?(ft.name.downcase)
      end
      return false
    end

  end
end

