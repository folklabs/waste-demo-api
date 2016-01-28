require 'collective/api'

require 'dotenv'
Dotenv.load

TWO_WEEKS = 60*60*24*14


describe Collective::Api::Site do

  it "gets a place" do
    place = Collective::Api::Site.find(100080140483)

    expect(place.uprn).to eq(100080140483)
  end

  it "gets a list of places by postcode" do
    # places = Collective::Api::Site.all(postcode: "GU1 2AA")
    places = Collective::Api::Site.all(postcode: "LU1 1RJ")

    expect(places.count).to eq(15)
    # puts places.count
  end

end


