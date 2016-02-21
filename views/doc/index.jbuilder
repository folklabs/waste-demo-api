json.set! 'title', "Waste Services API"
json.set! 'description', "A common API for local government waste services."

# json.organizations "#{request.base_url}organizations"
json.services "#{request.base_url}/services"
json.case_types "#{request.base_url}/case-types"
json.cases "#{request.base_url}/cases"
json.event_types "#{request.base_url}/event-types"
json.events "#{request.base_url}/events"
json.feature_types "#{request.base_url}/feature-types"
json.features "#{request.base_url}/features"
json.sites "#{request.base_url}/sites"
json.tasks "#{request.base_url}/tasks"

json.examples do
  json.services_by_uprn "#{request.base_url}/services?uprn=#{@uprn}"
  json.tasks_by_uprn "#{request.base_url}/tasks?uprn=#{@uprn}"
  json.events_by_uprn "#{request.base_url}/events?uprn=#{@uprn}"
end
