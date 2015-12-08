module Collective
  class Session

    def initialize
      @auth_token = get_token
      # puts ENV['COLLECTIVE_URL']
      # @client = Savon.client(wsdl: ENV['COLLECTIVE_URL'], log:true, log_level: :debug, logger: Rails.logger, pretty_print_xml: true) do
      @client = Savon.client(wsdl: ENV['COLLECTIVE_URL'], log:true, log_level: :debug, pretty_print_xml: true) do
        convert_request_keys_to :none
      end
    end

    def get_token
      # puts ENV['COLLECTIVE_AUTH_URL']
      auth_client = Savon.client(wsdl: ENV['COLLECTIVE_AUTH_URL'])
      # puts client.operations
      message = { user: ENV['COLLECTIVE_USERNAME'], password: ENV['COLLECTIVE_PASSWORD'] }
      response = auth_client.call(:authenticate, message: message)
      # puts response.body
      return response.body[:authenticate_response][:authenticate_result][:token][:token_string]
    end

    def call(method, message = {})
      # puts method
      # puts message
      # puts @auth_token
      # Insert auth token into body
      message[:token] = @auth_token
      response = @client.call(method, message: message)
      
      response_data = response.body[:"#{method}_response"]
      # puts response_data
      result = response_data[:"#{method}_result"]
    end
  end
end
