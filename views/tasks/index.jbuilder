# json.member do
  json.array!(@tasks) do |task|
    json.partial! 'tasks/_task', task: task
#  json.extract! task, :id, :name, :frequency, :esd_id, :organization
#  json.url api_task_url(task)
  end
# end
