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
require "sinatra/json"
require 'tilt/jbuilder'
require 'sinatra/jbuilder'
require 'ostruct'
require "yaml"
require "hashie"
require 'collective/api'
require 'serializers/collection'
require 'serializers/waste_service_collection'
require 'serializers/waste_service'
require 'serializers/task'

require 'oat/adapters/hal'
require 'oat/adapters/json_api'
require 'oat/adapters/siren'

require 'oat_hydra/adapters/hydra'

# 4 week time period
DEFAULT_TIME_PERIOD = 60*60*24*28
past_date = DateTime.parse((Time.now - DEFAULT_TIME_PERIOD).to_s)
future_date = DateTime.parse((Time.now + DEFAULT_TIME_PERIOD).to_s)


config_file 'config.yml'

helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

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
  header_auth_valid = request.env['HTTP_AUTH'] != nil and request.env['HTTP_AUTH'] == ENV['HTTP_AUTH']
  param_auth_valid = params['api_key'] != nil and params['api_key'] == ENV['HTTP_AUTH']
  unless header_auth_valid or param_auth_valid
    # halt 403
  end
end

get '/' do
  redirect to('/doc')
end

get '/doc' do
  jbuilder :'doc/index'
end


get '/services' do
  if params['uprn']
    @tasks = collections_in_date_range(params['uprn'], past_date, future_date)
  end
  @services = settings.services.map { |s| Hashie::Mash.new(s) }

  json WasteServiceCollectionSerializer.new(@services, {request: request}, Oat::Adapters::Hydra).to_hash
end


get '/services/:id' do
  if params['uprn']
    @tasks = collections_in_date_range(params['uprn'], past_date, future_date)
  end
  @service = Hashie::Mash.new(settings.services[params['id'].to_i])

  # jbuilder :'services/show'

  json WasteServiceSerializer.new(@service, {request: request}, Oat::Adapters::Hydra).to_hash
end


get '/events' do
  @events = Collective::Api::WasteEvent.all(params)

  jbuilder :'events/index'
end


get '/events/:id' do
  @event = Collective::Api::WasteEvent.find(params[:id])

  jbuilder :'events/show'
end

get '/sites' do
  @sites = Collective::Api::Site.all(params)
  
  jbuilder :'sites/index'
end


get '/sites/:id' do
  @site = Collective::Api::Site.find(params[:id])

  jbuilder :'sites/show'
end


get '/tasks' do
  @tasks = Collective::Api::Task.all(params)

  json CollectionSerializer.new(@tasks).to_hash
end


get '/tasks/:id' do
  @task = Collective::Api::Task.find(params[:id])
  content_type :json
  # jbuilder :'tasks/show'
  json TaskSerializer.new(@task).to_hash
  # TaskSerializer.new(@task).to_hash.to_json
end



