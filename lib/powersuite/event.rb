require 'json'

module Powersuite
  class Event < Base

    map_method 'id', 'log_id'
    map_method 'description', 'log_message'
    map_method 'start_date', 'log_date'

    def self.all(args = {})
      Base.process_params(args)
      args[:_wrapper] = :logInput
      data = self.get_site_logs(args)
      events = self.create_api_objects(data[:logs], Powersuite::Event, :log)
    end

    # TODO: fix when its possible to query for an event by ID. Need to assess if
    # this is worth having.
    def self.find(id)
      events = self.all
      matched = events.select {|t| t.id == id }
      matched[0] if matched.size > 0
    end

    def event_type
      # @json[:event_type][:description]
    end

    def task_id
      @json[:job][:id] if @json[:job]
    end

    def location
      Site.new({uprn: @json[:uprn], location: @json[:event_location]})
    end

  end
end

