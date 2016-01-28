require 'collective/api'

require 'dotenv'
Dotenv.load


describe Collective::Api::EventType do

  it "gets a list of event types" do
    types = Collective::Api::EventType.all()

    expect(types.count).to be > 1
  end

  # it "gets a list of places by postcode" do
  #   # places = Collective::Api::Site.all(postcode: "GU1 2AA")
  #   places = Collective::Api::Site.all(postcode: "LU1 1RJ")

  #   expect(places.count).to eq(15)
  #   # puts places.count
  # end

end
