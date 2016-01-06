module Collective::Api
  class WasteEvent < Base

    map_method 'id'
    # map_method 'description'
    # map_method 'scheduled_end_time', 'scheduled_finish'

    def self.all(args = {})

      # if args[:postcode]
      #   args[:Postcode] = args[:postcode]
      #   args.delete(:postcode)
      # end
      # puts args
      # todo: Move into helper method
      if args['uprn']
        args['UPRN'] = args['uprn']
        args.delete('uprn')
      end
      if args['date_range']
        # puts 'parsing date range'
        dates = args['date_range'].split(',')
        args.delete('date_range')
        args[:DateRange] = {MinimumDate: dates[0], MaximumDate: dates[1]}
      end
      data = Collective::Base.premises_events_get(args)
      # puts data.count
      puts JSON.pretty_generate(data)
      # puts data
      #TODO: nil items
      events = []
      if data[:@record_count].to_i == 1
        # Single object is given if just one, otherwise its a list
        events = [Collective::Api::WasteEvent.new(data[:event])]
      elsif data[:@record_count].to_i > 1
        events = data[:event].map do |p|
          # puts p[:uprn]
          Collective::Api::WasteEvent.new(p)
          # puts p
        end
      end
      # puts data
      # Place.new(data[:premises])
    end

    # TODO: fix when its possible to query for an event by ID. Need to assess if
    # this is worth having.
    def self.find(id)
      # data = Collective::Event.jobs_detail_get({JobID: id})
      # # puts data
      # puts JSON.pretty_generate(data)
      # # # TODO: data available?
      # Task.new(data[:job])
    end

    def start_date
      @json[:event_date]
    end

    def event_type
      @json[:event_type][:description]
    end

    def task_id
      @json[:job][:id] if @json[:job]
    end

    def location
      Site.new({uprn: @json[:uprn], location: @json[:event_location]})
    end
  end
end

