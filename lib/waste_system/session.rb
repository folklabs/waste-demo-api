require 'uri'

require 'active_support/core_ext/string'
require "savon"

module WasteSystem
  class Session

    def self.get
      case ENV['SYSTEM']
      when 'collective'
        Collective::Session.new
      when 'powersuite'
        Powersuite::Session.new
      end
    end

    def initialize(wsdl_url)
      # @auth_token = get_token
      # @client = Savon.client(wsdl: wsdl_url, log:true, log_level: :debug, pretty_print_xml: true) do
      @client = Savon.client(wsdl: wsdl_url) do
        convert_request_keys_to :none
      end
    end

    def call(method, message = {})
      d "Calling SOAP API with #{message}"
      response = @client.call(method, message: message)
      response_data = response.body[:"#{method}_response"]
      d response_data
      result = response_data[:"#{method}_result"]
    end

    def resource_class(path_info)
      first_part = path_info.split('/')[1]
      class_name = first_part.singularize.titleize.sub(/ /, '')
      full_class_name = "#{self.class.name.deconstantize}::#{class_name}"
      full_class = full_class_name.constantize
    end
  end
end

