module Powersuite
  class Task < Base

    attr_accessor :container_type

    map_method 'name', 'service'
    # map_method 'status'
    
    map_method 'start_date', 'date'
    # map_method 'end_date', 'actual_end'
    # map_method 'scheduled_start_date', 'scheduled_start'
    # map_method 'scheduled_end_date', 'scheduled_finish'

    def self.all(args = {})
      # Add today as default start date if no date specified
      unless args[:start_date]
        args[:start_date] = DateTime.now.to_date.to_s
      end

      Base.process_params(args)
      args[:'_wrapper'] = :getCollectionByUprnAndDateInput

      data = self.get_collection_by_uprn_and_date(args)

      tasks = []
      if data[:error_code].to_i == 0
        tasks = data[:collections][:collection].map do |data|
          Task.new(data, args[:Uprn])
        end
      end

      if args[:include]
        if args[:include].split(',').include?('related')
          tasks += get_related_tasks(args[:Uprn])
        end
      end

      tasks
    end

    def self.get_related_tasks(uprn)
      site = Site.find(uprn)
      tasks = []
      if site.parent_uprn
        tasks = self.all(uprn: site.parent_uprn)
      end
    end

    def self.find(id)
    end

    def initialize(data, uprn)
      super(data)
      @uprn = uprn
    end

    def id
      "#{@json[:round].sub(/ /, '-')}-#{start_date}"
    end

    def start_date
      Date.parse(@json[:date]).iso8601
    end

    def location
      Site.find(@uprn)
    end

  end
end

