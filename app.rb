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
require "log_buddy"
require 'active_support/inflector'


require 'oat/adapters/hal'
require 'oat/adapters/json_api'
require 'oat/adapters/siren'

require 'oat_hydra/adapters/hydra'

require 'waste_system'
require 'collective'
require 'powersuite'
require 'serializers'


# 3 week time period
DEFAULT_TIME_PERIOD = 60 * 60 * 24 * 21


config_file 'config.yml'


configure :development do
  require "better_errors"
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__

  log_file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  log_file.sync = true
  use Rack::CommonLogger, log_file
  # $stdout.reopen(log_file)
  # $stderr.reopen(log_file)
  # WasteSystem::Session.logger = logger
end


configure do
  enable :cross_origin
end


helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def respond_with_collection(items, opts)
    opts[:request] = request
    adapter = select_adapter
    json CollectionSerializer.new(items, opts, adapter).to_hash
  end

  def respond_with_item(item, serializer_class, opts = {})
    opts[:request] = request
    adapter = select_adapter
    json serializer_class.new(item, opts, adapter).to_hash
  end

  def select_adapter    
    adapters = request.accept.map do |type|
      case type.to_s
      when 'application/json-ld'
        Oat::Adapters::Hydra
      when 'application/vnd.api+json'
        Oat::Adapters::JsonAPI
      when 'application/vnd.siren+json'
        Oat::Adapters::Siren
      when 'application/hal+json'
        Oat::Adapters::HAL
      end
    end
    adapter = adapters.first || Oat::Adapters::Hydra
  end

  # Filter by a time range to include at least one past or future task
  def get_filtered_tasks(params)
    past_date = DateTime.parse((Time.now - DEFAULT_TIME_PERIOD).to_s).to_s
    params['start_date'] = past_date unless params['start_date']
    future_date = DateTime.parse((Time.now + DEFAULT_TIME_PERIOD).to_s).to_s
    params['end_date'] = future_date unless params['end_date']
    task_class = WasteSystem::Session.get.resource_class("/tasks")
    task_class.all(params)
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

  LogBuddy.init :logger => logger
end


get '/' do
  redirect to('/doc')
end

get '/doc' do
  @uprn = ENV['TEST_UPRN']
  jbuilder :'doc/index'
end


get '/services' do
  @tasks = get_filtered_tasks(params) if params['uprn']
  @services = WasteSystem::Session.get.services(settings, params)
  respond_with_collection(@services, name: 'services', serializer: WasteServiceSerializer, tasks: @tasks)
end


get '/services/:id' do
  @tasks = get_filtered_tasks(params) if params['uprn']
  services = WasteSystem::Session.get.services(settings, params)
  @service = services.find { |s| s.id == params['id'] }
  respond_with_item(@service, WasteServiceSerializer, tasks: @tasks)
end


get '/cases' do
  klass = WasteSystem::Session.get.resource_class(request.path_info)
  @collection = klass.all(params)
  respond_with_collection(@collection, name: 'cases', serializer: CaseSerializer)
end

get '/case-types' do
  klass = WasteSystem::Session.get.resource_class(request.path_info)
  @collection = klass.all(params)
  respond_with_collection(@collection, name: 'case-types', serializer: CaseTypeSerializer)
end


get '/event-types' do
  klass = WasteSystem::Session.get.resource_class(request.path_info)
  @event_types = klass.all(params)
  respond_with_collection(@event_types, name: 'event-types', serializer: EventTypeSerializer)
end


get '/event-types/:id' do
  klass = WasteSystem::Session.get.resource_class(request.path_info)
  @event_type = feature_class.find(params[:id])
  respond_with_item(@event_type, EventTypeSerializer)
end


get '/events' do
  event_class = WasteSystem::Session.get.resource_class(request.path_info)
  @events = event_class.all(params)
  respond_with_collection(@events, name: 'events', serializer: WasteEventSerializer)
end


get '/events/:id' do
  event_class = WasteSystem::Session.get.resource_class(request.path_info)
  @event = event_class.find(params[:id])
  respond_with_item(@event, WasteEventSerializer)
end


get '/feature-types' do
  klass = WasteSystem::Session.get.resource_class(request.path_info)
  @collection = klass.all(params)
  respond_with_collection(@collection, name: 'feature-types', serializer: FeatureTypeSerializer)
end


get '/feature-types/:id' do
  klass = WasteSystem::Session.get.resource_class(request.path_info)
  @item = klass.find(params[:id])
  respond_with_item(@item, FeatureTypeSerializer)
end


get '/features' do
  feature_class = WasteSystem::Session.get.resource_class(request.path_info)
  @collection = feature_class.all(params)
  respond_with_collection(@collection, name: 'features', serializer: FeatureSerializer)
end


get '/features/:id' do
  feature_class = WasteSystem::Session.get.resource_class(request.path_info)
  @feature = feature_class.find(params[:id])
  respond_with_item(@feature, FeatureSerializer)
end


get '/sites' do
  site_class = WasteSystem::Session.get.resource_class(request.path_info)
  @sites = site_class.all(params)
  respond_with_collection(@sites, name: 'sites', serializer: SiteSerializer)
end


get '/sites/:id' do
  site_class = WasteSystem::Session.get.resource_class(request.path_info)
  @site = site_class.find(params[:id])
  respond_with_item(@site, SiteSerializer)
end


get '/tasks' do
  task_class = WasteSystem::Session.get.resource_class(request.path_info)
  @tasks = task_class.all(params)
  respond_with_collection(@tasks, name: 'tasks', serializer: TaskSerializer)
end


get '/tasks/:id' do
  task_class = WasteSystem::Session.get.resource_class(request.path_info)
  @task = task_class.find(params[:id])
  respond_with_item(@task, TaskSerializer)
end



