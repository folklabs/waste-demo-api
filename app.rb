require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'

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
require 'active_support/inflector'

require 'serializers/collection'
require 'serializers/event_type'
require 'serializers/feature'
require 'serializers/feature_type'
require 'serializers/site'
require 'serializers/waste_event'
require 'serializers/waste_service'
require 'serializers/task'

require 'oat/adapters/hal'
require 'oat/adapters/json_api'
require 'oat/adapters/siren'

require 'oat_hydra/adapters/hydra'

require 'waste_system'
require 'collective'
require 'powersuite'


configure :development do
  require "better_errors"
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

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
      task_start_time = task.scheduled_start_date
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

  def respond_with_collection(items, opts)
    opts[:request] = request
    adapter = select_adapter
    json CollectionSerializer.new(items, opts, adapter).to_hash
  end

  def respond_with_item(serializer_class, item, opts = {})
    opts[:request] = request
    adapter = select_adapter
    json serializer_class.new(item, opts, adapter).to_hash
  end

  def select_adapter
    adapter = Oat::Adapters::Hydra
    request.accept.each do |type|
      case type.to_s
      when 'application/json-ld'
        # This is default
      when 'application/vnd.api+json'
        adapter = Oat::Adapters::JsonAPI
      when 'application/vnd.siren+json'
        adapter = Oat::Adapters::Siren
      when 'application/hal+json'
        adapter = Oat::Adapters::HAL
      end
    end
    adapter
  end

  def session
    case ENV['SYSTEM']
    when 'collective'
      Collective::Session.new
    when 'powersuite'
      Powersuite::Session.new
    end
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
  @services = WasteSystem::Session.get.services(settings, params)

  respond_with_collection(@services, { name: 'services', serializer: WasteServiceSerializer })
end


get '/services/:id' do
  if params['uprn']
    @tasks = collections_in_date_range(params['uprn'], past_date, future_date)
  end
  @service = Hashie::Mash.new(settings.services[params['id'].to_i])
  respond_with_item(WasteServiceSerializer, @service)
end


get '/event-types' do
  clazz = WasteSystem::Session.get.resource_class(request.path_info)
  @event_types = clazz.all(params)
  respond_with_collection(@event_types, { name: 'event-types', serializer: EventTypeSerializer })
end


get '/event-types/:id' do
  clazz = WasteSystem::Session.get.resource_class(request.path_info)
  @event_type = feature_class.find(params[:id])
  respond_with_item(EventTypeSerializer, @event_type)
end


get '/events' do
  event_class = WasteSystem::Session.get.resource_class(request.path_info)
  @events = event_class.all(params)
  respond_with_collection(@events, { name: 'events', serializer: WasteEventSerializer })
end


get '/events/:id' do
  event_class = WasteSystem::Session.get.resource_class(request.path_info)
  @event = event_class.find(params[:id])
  respond_with_item(WasteEventSerializer, @event)
end


get '/feature-types' do
  clazz = WasteSystem::Session.get.resource_class(request.path_info)
  @collection = clazz.all(params)
  respond_with_collection(@collection, { name: 'feature-types', serializer: FeatureTypeSerializer })
end


get '/feature-types/:id' do
  clazz = WasteSystem::Session.get.resource_class(request.path_info)
  @item = clazz.find(params[:id])
  respond_with_item(FeatureTypeSerializer, @item)
end


get '/features' do
  feature_class = WasteSystem::Session.get.resource_class(request.path_info)
  @collection = feature_class.all(params)
  respond_with_collection(@collection, { name: 'features', serializer: FeatureSerializer })
end


get '/features/:id' do
  feature_class = WasteSystem::Session.get.resource_class(request.path_info)
  @feature = feature_class.find(params[:id])
  respond_with_item(FeatureSerializer, @feature)
end


get '/sites' do
  site_class = WasteSystem::Session.get.resource_class(request.path_info)
  @sites = site_class.all(params)
  respond_with_collection(@sites, { name: 'sites', serializer: SiteSerializer })
end


get '/sites/:id' do
  site_class = WasteSystem::Session.get.resource_class(request.path_info)
  @site = site_class.find(params[:id])
  respond_with_item(SiteSerializer, @site)
end


get '/tasks' do
  task_class = WasteSystem::Session.get.resource_class(request.path_info)
  @tasks = task_class.all(params)
  respond_with_collection(@tasks, { name: 'tasks', serializer: TaskSerializer } )
end


get '/tasks/:id' do
  task_class = WasteSystem::Session.get.resource_class(request.path_info)
  @task = task_class.find(params[:id])
  respond_with_item(TaskSerializer, @task)
end



