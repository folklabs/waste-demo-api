module Collective::Api
  class Task < Base

    attr_accessor :container_type

    map_method 'id'
    map_method 'name'
    map_method 'status'
    map_method 'scheduled_end_time', 'scheduled_finish'

    def self.all(args = {})

      # if args[:postcode]
      #   args[:Postcode] = args[:postcode]
      #   args.delete(:postcode)
      # end
      if args['uprn']
        args['UPRN'] = args['uprn']
        args.delete('uprn')
      end
      if args['schedule_start']
        # puts 'parsing date range'
        dates = args['schedule_start'].split(',')
        args.delete('schedule_start')
        args[:ScheduleStart] = {MinimumDate: dates[0], MaximumDate: dates[1]}
      end
      data = Collective::Job.jobs_get(args)
      # puts data.count
      #TODO: nil items
      tasks = []
      if data[:@record_count].to_i > 0
        tasks = data[:jobs].map do |p|
          # puts p[:uprn]
          Collective::Api::Task.new(p[:job])
          # puts data
        end
      end
      # puts data
      # puts JSON.pretty_generate(data)
      tasks
      # Place.new(data[:premises])
    end

    def self.find(id)
      data = Collective::Job.jobs_detail_get({JobID: id})
      # puts data
      # puts JSON.pretty_generate(data)
      # # TODO: data available?
      Task.new(data[:job])
    end

    def status
      # puts @json[:status][:status]
      @json[:status][:status].downcase if @json[:status]
    end

    def start_time
      # puts @json[:actual_start]
      @json[:actual_start]
    end

    def end_time
      @json[:actual_end]
    end

    def scheduled_time
      @json[:scheduled_start]
    end

    def location
      Site.new(@json[:premises])
    end

    def events
      data = Collective::Api::WasteEvent.all(UPRN: location.uprn, WorkPack: @json[:work_pack][:name])
      data
    end
  end
end

