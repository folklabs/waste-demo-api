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
require 'serializers/site'
require 'serializers/waste_event'
require 'serializers/waste_service'
require 'serializers/task'

require 'oat/adapters/hal'
require 'oat/adapters/json_api'
require 'oat/adapters/siren'

require 'oat_hydra/adapters/hydra'


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
    json CollectionSerializer.new(items, opts, Oat::Adapters::Hydra).to_hash
  end

  def respond_with_item(serializer_class, item, opts = {})
    opts[:request] = request
    json serializer_class.new(item, opts, Oat::Adapters::Hydra).to_hash
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
  @event_types = Collective::Api::EventType.all(params)

  jbuilder :'event_types/index'
end


get '/event-types/:id' do
  @event_type = Collective::Api::EventType.find(params[:id])

  jbuilder :'event_types/show'
end


get '/events' do
  @events = Collective::Api::WasteEvent.all(params)

  respond_with_collection(@events, { name: 'events', serializer: WasteEventSerializer })
end


get '/events/:id' do
  @event = Collective::Api::WasteEvent.find(params[:id])

  respond_with_item(WasteEventSerializer, @event)
end


get '/feature-types' do
  @feature_types = Collective::Api::FeatureType.all(params)

  jbuilder :'feature_types/index'
end


get '/feature-types/:id' do
  @feature_type = Collective::Api::FeatureType.find(params[:id])

  jbuilder :'feature_types/show'
end


get '/features' do
  @features = Collective::Api::Feature.all(params)

  jbuilder :'features/index'
end


get '/features/:id' do
  @feature = Collective::Api::Feature.find(params[:id])

  jbuilder :'features/show'
end


get '/sites' do
  @sites = Collective::Api::Site.all(params)

  respond_with_collection(@sites, { name: 'sites', serializer: SiteSerializer })
end


get '/sites/:id' do
  @site = Collective::Api::Site.find(params[:id])

  respond_with_item(SiteSerializer, @site)
end


get '/tasks' do
  @tasks = Collective::Api::Task.all(params)

  respond_with_collection(@tasks, { name: 'tasks', serializer: TaskSerializer } )
end


get '/tasks/:id' do
  @task = Collective::Api::Task.find(params[:id])

  respond_with_item(TaskSerializer, @task)
end



