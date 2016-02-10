require "savon"

require "waste_system"

module Collective
  class Session < WasteSystem::Session

    def initialize
      super(ENV['COLLECTIVE_URL'])
      @auth_token = get_token
      # # @client = Savon.client(wsdl: ENV['COLLECTIVE_URL'], log:true, log_level: :debug, pretty_print_xml: true) do
      # @client = Savon.client(wsdl: ENV['COLLECTIVE_URL']) do
      #   convert_request_keys_to :none
      # end
    end

    def get_token
      auth_client = Savon.client(wsdl: ENV['COLLECTIVE_AUTH_URL'])
      message = { user: ENV['COLLECTIVE_USERNAME'], password: ENV['COLLECTIVE_PASSWORD'] }
      response = auth_client.call(:authenticate, message: message)
      return response.body[:authenticate_response][:authenticate_result][:token][:token_string]
    end

    def call(method, message = {})
      # Insert auth token into request message
      message[:token] = @auth_token
      response = @client.call(method, message: message)
      
      response_data = response.body[:"#{method}_response"]
      # puts response_data
      result = response_data[:"#{method}_result"]
    end

    def services(settings, params)
      services = settings.collective['services'].map { |s| Hashie::Mash.new(s) }
    end
  end
end
