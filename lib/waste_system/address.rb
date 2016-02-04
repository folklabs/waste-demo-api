module WasteSystem
  module Address

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

