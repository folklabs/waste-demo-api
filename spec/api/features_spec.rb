require 'spec_helper'

describe 'features' do

  it 'should have types' do
    get '/features'
    expect_jsonld_collection
  end

end

