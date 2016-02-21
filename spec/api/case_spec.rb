require 'spec_helper'

describe 'cases' do

  it 'should have types' do
    get "/cases"
    expect_jsonld_collection
  end

end

