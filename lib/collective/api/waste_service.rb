module Collective::Api
  class WasteService < Base

  #   map_method 'id'
  #   map_method 'name'
  #   map_method 'scheduled_end_time', 'scheduled_finish'

  #   def self.all(args = {})

  #     # if args[:postcode]
  #     #   args[:Postcode] = args[:postcode]
  #     #   args.delete(:postcode)
  #     # end
  #     puts args
  #     if args['schedule_start']
  #       # puts 'parsing date range'
  #       dates = args['schedule_start'].split(',')
  #       args.delete('schedule_start')
  #       args[:ScheduleStart] = {MinimumDate: dates[0], MaximumDate: dates[1]}
  #     end
  #     data = Collective::Job.jobs_get(args)
  #     # puts data.count
  #     #TODO: nil items
  #     tasks = data[:jobs].map do |p|
  #       # puts p[:uprn]
  #       Collective::Api::Task.new(p[:job])
  #       # puts data
  #     end
  #     # puts data
  #     # Place.new(data[:premises])
  #   end

  #   def self.find(id)
  #     data = Collective::Job.jobs_detail_get({JobID: id})
  #     # puts data
  #     puts JSON.pretty_generate(data)
  #     # # TODO: data available?
  #     Task.new(data[:job])
  #   end

  #   def start_time
  #     @json[:actual_start]
  #   end

  #   def end_time
  #     @json[:actual_end]
  #   end

  #   def scheduled_time
  #     @json[:scheduled_start]
  #   end

  #   def location
  #     Place.new(@json[:premises])
  #   end
  end
end

