module Collective::Api
  class WasteEvent < Base

    map_method 'id'
    map_method 'start_date', 'event_date'

    def self.all(args = {})
      Base.process_params(args)

      events = []
      data = Collective::Base.premises_events_get(args)
      events = create_api_objects(data, Collective::Api::WasteEvent)

      data = Collective::Base.streets_events_get(args)
      events += create_api_objects(data, Collective::Api::WasteEvent)
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

