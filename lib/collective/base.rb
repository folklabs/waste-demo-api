module Collective
  class Base
    def get_token
      client = Savon.client(wsdl: ENV['COLLECTIVE_AUTH_URL'])
      message = { user: ENV['COLLECTIVE_USERNAME'], password: ENV['COLLECTIVE_PASSWORD'] }
      response = client.call(:authenticate, message: message)
      return response.body[:authenticate_response][:authenticate_result][:token][:token_string]
    end

    def self.method_missing(m, *args, &block)  
      session = Collective::Session.new
      args = {} if args.size == 0
      args = args[0] if args.size == 1
      result = session.call(:"#{m}", args)
      result
    end  
  end
end

