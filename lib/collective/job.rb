module Collective
  # class ServiceRequest

  #   def to_s
  #     builder = Builder::XmlMarkup.new
  #     builder.instruct!(:xml, encoding: "UTF-8")

  #     builder.person { |b|
  #       b.username("luke")
  #       b.password("secret")
  #     }

  #     builder
  #   end

  # end

  class Job < Base
    def initialize(session)
      @session = session
    end

    def get(message = {})
      # message[:'Bounds/'] = '' if message[:Bounds] == nil
      response = @session.call(:jobs_get, message)
      data = response[:premises]
    end

    # def events(message = {})
    #   message[:'Events_Bounds/'] = '' if message[:Events_Bounds] == nil
    #   message[:'Premises_Bounds/'] = '' if message[:Premises_Bounds] == nil
    #   response = @session.call(:premises_events_get, message)
    # end

    # def event_types
    #   response = @session.call(:premises_events_types_get)
    #   data = response[:event_types]
    # end
  end
end
