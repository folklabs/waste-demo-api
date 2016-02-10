require 'airborne'

TWO_WEEKS = 60 * 60 * 24 * 14

Airborne.configure do |config|
  config.base_url = 'http://localhost:4567'
  # config.include StubHelper
end

def test_uprn
  return '100060000072'
end

def date_2_weeks_ago
  DateTime.parse((Time.now - TWO_WEEKS).to_s)
end

def date_2_weeks_forward
  DateTime.parse((Time.now + TWO_WEEKS).to_s)
end

def expect_jsonld_collection
  # expect_json_types('@type': :string)
  # expect_json('@type': "Collection")
  # expect_json_types('@id': :string)
  expect_json_types('totalItems': :int)
end

