module Collective::Api
  class Address < Base

    def paon
      @json[:address2]
    end

    def saon
      @json[:address1]
    end

    def street
      @json[:street]
    end

    def locality
      @json[:locality]
    end

    def town
      @json[:town]
    end

    def postcode
      @json[:post_code]
    end

    def to_s
      text = "#{street}"
      text = "#{paon} #{text}" if paon
      text = "#{saon}, #{text}" if saon
      text = "#{text}, #{locality}" if locality
      text = "#{text}, #{town}" if town
      text = "#{text}, #{postcode}" if postcode
    end

    def description
      to_s
    end

  end
end

