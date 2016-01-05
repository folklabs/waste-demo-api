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


# 4 week time period
DEFAULT_TIME_PERIOD = 60*60*24*28
past_date = DateTime.parse((Time.now - DEFAULT_TIME_PERIOD).to_s)
future_date = DateTime.parse((Time.now + DEFAULT_TIME_PERIOD).to_s)


config_file 'config.yml'

helpers do
  def collections_in_date_range(uprn, start_date, end_date)
    tasks = Collective::Api::Task.all({'UPRN'=> uprn, 'schedule_start'=> "#{start_date},#{end_date}", 'Jobs_Bounds' =>'', 'show_events' => 'true'})
  end

  def filter_tasks(tasks, service, start_date, end_date)
    matched_tasks = tasks.select do |task|
      is_valid = false
      task_start_time = task.scheduled_time
      if task_start_time >= start_date and task_start_time <= end_date
        service.feature_types.each do |ct|
          is_valid = true if task.name.downcase.include?(ct.name.downcase)
        end
      end
      is_valid
    end
  end

  def collections_in_date_range_by_service(uprn, service, start_date, end_date)
    tasks = collections_in_date_range(uprn, start_date, end_date)
    matched_tasks = tasks.select do |task|
      is_valid = false
      service.feature_types.each { |ct| is_valid = true if task.name.downcase.include?(ct.name.downcase) }
      is_valid
    end
  end

  def filter_last_collections(tasks, service)
      past_date = DateTime.parse((Time.now - DEFAULT_TIME_PERIOD).to_s)
      tasks = filter_tasks(tasks, service, past_date, DateTime.now)
  end

  def filter_next_collections(tasks, service)
    future_date = DateTime.parse((Time.now + DEFAULT_TIME_PERIOD).to_s)
    tasks = filter_tasks(tasks, service, DateTime.now, future_date)
  end
end


before do
  # logger.info(request.env['HTTP_AUTH'])
  # logger.info(ENV['HTTP_AUTH'])
  halt 403 unless request.env['HTTP_AUTH'] != nil and request.env['HTTP_AUTH'] == ENV['HTTP_AUTH']
end


get '/services' do
  if params['uprn']
    @tasks = collections_in_date_range(params['uprn'], past_date, future_date)
  end
  @services = settings.services.map { |s| Hashie::Mash.new(s) }

  jbuilder :'services/index'
end


get '/services/:id' do
  @service = Hashie::Mash.new(settings.services[params['id'].to_i])

  jbuilder :'services/show'
end


get '/events' do
  @events = Collective::Api::WasteEvent.all(request.query_parameters)

  jbuilder :'events/index'
end


get '/events/:id' do
  @event = Collective::Api::WasteEvent.find(params[:id])

  jbuilder :'events/show'
end

get '/sites' do
  @sites = Collective::Api::Site.all(request.query_parameters)
  
  jbuilder :'sites/index'
end


get '/sites/:id' do
  @site = Collective::Api::Site.find(params[:id])

  jbuilder :'sites/show'
end


get '/tasks' do
  puts params
  # Getting tasks across many properties not currently supported
  halt 501 if not params.has_key?('uprn')

  @tasks = Collective::Api::Task.all(params)

  jbuilder :'tasks/index'
end


get '/tasks/:id' do
  @task = Collective::Api::Task.find(params[:id])

  jbuilder :'tasks/show'
end



