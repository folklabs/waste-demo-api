require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'json'
require 'sinatra'
require 'tilt/jbuilder'
require 'sinatra/jbuilder'
require 'ostruct'
require "yaml"
require "hashie"
require 'collective/api'


get '/' do
  "Hello world!\n"
end

helpers do
#   def get_data(data_type)
#     data = YAML.load_file("spec/data/#{data_type}.yml")
#     objects = data.map do |e|
#       hash = Hash[e.map{|(k,v)| [k.to_sym, v]}]
#       obj = OpenStruct.new(hash)
#     end
#   end

#   def get_data_json(data_type)
#     data = JSON.parse(File.read("examples/#{data_type}.json"))
#     if data.kind_of?(Array)
#       objects = data.map do |e|
#         hash = Hash[e.map{|(k,v)| [k.to_sym, v]}]
#         event = OpenStruct.new(hash)
#       end
#     else
#       object = OpenStruct.new(Hash[data])
#     end
#   end

#   def get_json(data_type)
#     data = File.read("examples/#{data_type}.json")
#   end
end


get '/services' do
  # @services = Collective::Api::Service.all

  jbuilder :'services/index'
end


get '/events' do
  @events = Collective::Api::WasteEvent.all(request.query_parameters)
  jbuilder :'events/index'
end


get '/events/:id' do
  puts params['id']
  @event = Collective::Api::WasteEvent.find(params[:id])

  jbuilder :'events/show'
end

get '/sites' do
  @sites = Collective::Api::Site.all(request.query_parameters)
  jbuilder :'sites/index'
end


get '/sites/:id' do
  puts params['id']
  @site = Collective::Api::Site.find(params[:id])

  jbuilder :'sites/show'
end


# get '/tasks' do
#   # @events = get_data('events')

#   jbuilder :'tasks/index'
# end


get '/tasks/:id' do
  @task = Collective::Api::Task.find(params[:id])

  jbuilder :'tasks/show'
end



