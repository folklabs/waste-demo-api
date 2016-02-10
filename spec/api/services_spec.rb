require 'spec_helper'

describe 'services' do

  it 'should have types' do
    get '/services'
    expect_jsonld_collection
  end

end

