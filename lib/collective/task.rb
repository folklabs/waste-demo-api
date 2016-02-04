module Collective
  class Task < Base

    attr_accessor :container_type

    map_method 'id'
    map_method 'name'
    map_method 'status'
    
    map_method 'start_date', 'actual_start'
    map_method 'end_date', 'actual_end'
    map_method 'scheduled_start_date', 'scheduled_start'
    map_method 'scheduled_end_date', 'scheduled_finish'

    # Older mappings preserved for now
    map_method 'start_time', 'actual_start'
    map_method 'scheduled_time', 'scheduled_start'


    def self.all(args = {})
      Base.process_params(args)
      if args['schedule_start']
        dates = args['schedule_start'].split(',')
        args.delete('schedule_start')
        # The Collective docs show this as "ScheduledStart"
        args[:ScheduleStart] = {MinimumDate: dates[0], MaximumDate: dates[1]}
      end
      data = Collective::Job.jobs_get(args)
      #TODO: nil items
      tasks = []
      if data[:@record_count].to_i > 0
        tasks = data[:jobs].map do |p|
          Collective::Task.new(p[:job])
        end
      end
      tasks
    end

    def self.find(id)
      data = Collective::Job.jobs_detail_get({JobID: id})
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

