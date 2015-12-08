module Collective
  class Premise < Base
    def initialize(session)
      @session = session
    end

    def get(message = {})
      # message[:'Bounds/'] = '' if message[:Bounds] == nil
      response = @session.call(:premises_get, message)
      data = response[:premises]
    end

    def events(message = {})
      message[:'Events_Bounds/'] = '' if message[:Events_Bounds] == nil
      message[:'Premises_Bounds/'] = '' if message[:Premises_Bounds] == nil
      response = @session.call(:premises_events_get, message)
    end

    def event_types(message = {})
      response = @session.call(:premises_events_types_get)
      data = response[:event_types]
    end
  end
end
