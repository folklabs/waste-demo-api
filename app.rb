# myapp.rb
require 'json'
require 'sinatra'
require 'tilt/jbuilder'
require 'sinatra/jbuilder'
require 'ostruct'
require "yaml"

get '/' do
  'Hello world!'
end

helpers do
  def get_data(data_type)
    data = YAML.load_file("spec/data/#{data_type}.yml")
    objects = data.map do |e|
      hash = Hash[e.map{|(k,v)| [k.to_sym, v]}]
      obj = OpenStruct.new(hash)
    end
  end

  def get_data_json(data_type)
    data = JSON.parse(File.read("../waste-service-standards/examples/#{data_type}.json"))
    if data.kind_of?(Array)
      objects = data.map do |e|
        hash = Hash[e.map{|(k,v)| [k.to_sym, v]}]
        event = OpenStruct.new(hash)
      end
    else
      object = OpenStruct.new(Hash[data])
    end
  end

  def get_json(data_type)
    data = File.read("../waste-service-standards/examples/#{data_type}.json")
  end
end


get '/waste/services' do
  headers "Content-Type" => "application/json"

  [200, get_json('service')]

  # jbuilder :services
end


get '/waste/events' do
  headers "Content-Type" => "application/json"

  @events = get_data('events')

  jbuilder :events
end


get '/waste/events/:id' do
  @events = get_data('events')
  puts params['id']
  # matching_events = @events.each { |item| puts item.id.to_s == params['id'] }
  matching_events = @events.select { |item| item.id.to_s == params['id'] }
  unless matching_events.empty?
    @event = matching_events[0]
    jbuilder :event
  # else
    # []
  end
end
