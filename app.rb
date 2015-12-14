require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'json'
require 'sinatra'
require 'sinatra/config_file'
require 'tilt/jbuilder'
require 'sinatra/jbuilder'
require 'ostruct'
require "yaml"
require "hashie"
require 'collective/api'


TWO_WEEKS = 60*60*24*14


config_file 'config.yml'

helpers do
  def collections_in_date_range(uprn, service, start_date, end_date)
    tasks = Collective::Api::Task.all({'UPRN'=> uprn, 'schedule_start'=> "#{start_date},#{end_date}", 'Jobs_Bounds' =>'', 'show_events' => 'true'})
    matched_tasks = tasks.select do |task|
      is_valid = false
      service.container_types.each { |ct| is_valid = true if task.name.downcase.include?(ct.name.downcase) }
      is_valid
    end
  end

  def last_collections(uprn, service)
      date_2_weeks_ago = DateTime.parse((Time.now - TWO_WEEKS).to_s)
      tasks = collections_in_date_range(uprn, service, date_2_weeks_ago, DateTime.now.iso8601)
  end

  def next_collections(uprn, service)
    date_2_weeks_ahead = DateTime.parse((Time.now + TWO_WEEKS).to_s)
    tasks = collections_in_date_range(uprn, service, DateTime.now.iso8601, date_2_weeks_ahead)
  end
end


before do
  logger.info(request.env['HTTP_AUTH'])
  logger.info(ENV['HTTP_AUTH'])
  halt 403 unless request.env['HTTP_AUTH'] != nil and request.env['HTTP_AUTH'] == ENV['HTTP_AUTH']
end


get '/services' do
  @services = settings.services.map { |s| Hashie::Mash.new(s) }

  jbuilder :'services/index'
end


get '/services/:id' do
  @service = settings.services[params['id']]

  jbuilder :'services/show'
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
  # puts params['id']
  # puts settings.services
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



