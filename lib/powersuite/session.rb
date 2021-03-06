require "savon"

require "waste_system"

module Powersuite
  class Session < WasteSystem::Session

    def initialize
      super(ENV['POWERSUITE_URL'])
    end

    def call(method, message = {})
      if message[:_wrapper]
        new_message = Hash.new
        new_message[message[:_wrapper]] = message
        message.delete(:_wrapper)
        message = new_message
      end
      super(method, message)
    end

    def services(settings, params)
      services = Service.all(params)
      service_ids = settings.powersuite['services_filter']
      services = services.select { |service| service_ids.include?(service.id.to_i) }
    end

  end
end

