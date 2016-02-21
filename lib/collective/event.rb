module Collective
  class Event < Base

    map_method 'id'
    map_method 'start_date', 'event_date'

    def self.all(args = {})
      Base.process_params(args)

      data = self.premises_events_get(args)
      events = create_api_objects(data, Collective::Event, :event)

      data = self.premises_detail_get(UPRN: args[:UPRN])
      usrn = data[:usrn]
      data = self.streets_events_get(USRN: usrn)
      street_events = create_api_objects(data, Collective::Event, :event)
      events += street_events
    end

    # TODO: fix when its possible to query for an event by ID. Need to assess if
    # this is worth having.
    def self.find(id)
      events = self.all
      matched = events.select {|t| t.id == id }
      matched[0] if matched.size > 0
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

