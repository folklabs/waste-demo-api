module Collective
  class Task < Base

    attr_accessor :container_type

    map_method 'id'
    map_method 'name'
    map_method 'status'
    
    map_method 'start_date', 'scheduled_start'
    map_method 'end_date', 'scheduled_finish'
    map_method 'actual_start_date', 'actual_start'
    map_method 'actual_end_date', 'actual_finish'

    def self.all(args = {})
      Base.process_params(args)
      # Map a generic DateRange parameter to ScheduleStart that is used for 
      # Collective job filtering.
      convert_argument(args, :DateRange, :ScheduleStart)
      data = self.jobs_get(args)
      #TODO: nil items
      tasks = []
      if data[:@record_count].to_i > 0
        tasks = data[:jobs].map do |p|
          Collective::Task.new(p[:job])
        end
      end

      tasks += get_related_content(args, Task)
    end

    def self.find(id)
      data = self.jobs_detail_get({JobID: id})
      Task.new(data[:job])
    end

    def status
      @json[:status][:status].downcase if @json[:status]
    end

    def location
      Site.new(@json[:premises])
    end

    def events
      data = Collective::WasteEvent.all(UPRN: location.uprn, WorkPack: @json[:work_pack][:name])
    end
  end
end

