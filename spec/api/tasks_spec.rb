require 'spec_helper'

describe 'tasks' do
  it 'should have types' do
    today = DateTime.now.to_date.to_s
    date2 = date_2_weeks_forward
    # path = "/tasks?start_date=#{today}&uprn=#{test_uprn}"
    # get path
    get "/tasks?date_range=#{today},#{date2}&uprn=#{test_uprn}"
    # get "/tasks?start_date=" + today + "&uprn=" + test_uprn
    # get "/tasks"
    expect_jsonld_collection
  end

  # it 'should validate values' do
  #   get 'http://example.com/api/v1/simple_get' #json api that returns { "name" : "John Doe" }
  #   expect_json(name: 'John Doe')
  # end
end

