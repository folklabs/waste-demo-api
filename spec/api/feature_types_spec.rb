require 'spec_helper'

describe 'feature-types' do

  it 'should have types' do
    get "/feature-types"
    expect_jsonld_collection
  end

end

