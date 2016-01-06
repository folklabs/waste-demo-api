json.set! 'title', "Waste Services API"
json.set! 'description', "A common API for local government waste services."

# json.organizations "#{request.base_url}organizations"
json.services "#{request.base_url}/services"
json.events "#{request.base_url}/events"
json.sites "#{request.base_url}/sites"
json.tasks "#{request.base_url}/tasks"
