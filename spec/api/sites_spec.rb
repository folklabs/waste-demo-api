require 'spec_helper'

describe 'sites' do

  it 'should have types' do
    # today = DateTime.now.to_date.to_s
    # get "/tasks?start_date=#{today}&uprn=#{test_uprn}"
    # get "/tasks?start_date=" + today + "&uprn=" + test_uprn
    get "/sites"
    expect_jsonld_collection
  end

end

