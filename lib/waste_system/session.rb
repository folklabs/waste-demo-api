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
      @client = Savon.client(wsdl: wsdl_url, log:true, log_level: :debug, pretty_print_xml: true) do
      # @client = Savon.client(wsdl: ENV['POWERSUITE_URL']) do
        convert_request_keys_to :none
      end
    end

    def call(method, message = {})
      # Insert auth token into body
      # message[:token] = @auth_token
      # puts wrapper.class
      if message[:_wrapper]
        new_message = Hash.new
        new_message[message[:_wrapper]] = message
        puts new_message.class
        puts new_message
        message = new_message
      end
      response = @client.call(method, message: message)
      puts response
      response_data = response.body[:"#{method}_response"]
      puts response_data
      result = response_data[:"#{method}_result"]
    end

    def resource_class(path_info)
      # url_path = URL(url).path
      # puts path_info.split('/')
      first_part = path_info.split('/')[1]
      class_name = first_part.singularize.titleize.sub(/ /, '')
      # puts self.class.name.deconstantize
      full_class_name = "#{self.class.name.deconstantize}::#{class_name}"
      # puts full_class_name
      full_class = full_class_name.constantize
    end
  end
end

