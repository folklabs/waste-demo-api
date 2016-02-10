require 'spec_helper'

describe 'events' do

  it 'should have types' do
    get "/events"
    expect_jsonld_collection
  end

end

