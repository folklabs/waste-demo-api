require 'spec_helper'

describe 'services' do
  it 'should have types' do
    get 'http://localhost:4567/services' #json api that returns { "name" : "John Doe" }
    expect_jsonld_collection
  end

  # it 'should validate values' do
  #   get 'http://example.com/api/v1/simple_get' #json api that returns { "name" : "John Doe" }
  #   expect_json(name: 'John Doe')
  # end
end

