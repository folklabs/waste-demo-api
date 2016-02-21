require 'spec_helper'

describe 'event-types' do

  it 'should have types' do
    get "/event-types"
    expect_jsonld_collection
  end

end

