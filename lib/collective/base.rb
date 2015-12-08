module Collective
  class Base
    def get_token
      # puts ENV
      # client = Savon.client(wsdl: "https://ws.bartec-systems.com/Auth-TEST/Authenticate.asmx?WSDL")
      client = Savon.client(wsdl: ENV['COLLECTIVE_AUTH_URL'])
      # puts client.operations
      message = { user: ENV['COLLECTIVE_USERNAME'], password: ENV['COLLECTIVE_PASSWORD'] }
      response = client.call(:authenticate, message: message)

      # puts response.body
      
      return response.body[:authenticate_response][:authenticate_result][:token][:token_string]
    end

    def self.method_missing(m, *args, &block)  
      puts 'method_missing'
      puts args
      session = Collective::Session.new
      args = {} if args.size == 0
      args = args[0] if args.size == 1
      session.call(:"#{m}", args)
    end  
  end
end

