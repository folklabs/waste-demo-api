module Collective::Api
  class EventType < Base

    # map_method 'id'
    map_method 'name', 'description'

    def self.all(args = {})
      Base.process_params(args)
      
      data = Collective::Base.premises_events_types_get(args)
      event_types = create_api_objects(data, Collective::Api::EventType, :sub_event_types)
      event_types.each { |e| e.type = "SiteEventType" }

      data = Collective::Base.streets_events_types_get(args)
      street_events = create_api_objects(data, Collective::Api::EventType, :event_types)
      street_events.each { |e| e.type = "StreetEventType" }
      event_types += street_events
    end

    # TODO: fix when its possible to query for an event by ID. Need to assess if
    # this is worth having.
    def self.find(id)
      event_types = self.all
      matched = event_types.select {|t| t.id == id }
      matched[0] if matched.size > 0
    end

    def parent
      if @json[:event_type]
        parent = Collective::Api::EventType.new(@json[:event_type])
        parent.type = @type
        parent
      end
    end

    def id
      prefix = case @type
        when 'SiteEventType'
          "site-"
        when 'StreetEventType'
          "street-"
        else
          ""
      end
      id = "#{prefix}#{@json[:id]}"
    end
  end
end

