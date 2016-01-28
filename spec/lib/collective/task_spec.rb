require 'collective/api'

TWO_WEEKS = 60*60*24*14


describe Collective::Api::Task do
  it "gets list of tasks that includes related sites" do
    date_2_weeks_ago = DateTime.parse((Time.now - TWO_WEEKS).to_s)
    # tasks = Collective::Api::Task.all({ 'uprn' => 100080140483, 'include_related' => "true", 'schedule_start'=> "#{date_2_weeks_ago},#{DateTime.now.iso8601}" })
    # tasks = Collective::Api::Task.all({ 'uprn' => 10024036847, 'schedule_start'=> "#{date_2_weeks_ago},#{DateTime.now.iso8601}", 'Jobs_Bounds'=>'', 'include_related' => "false" })
    # tasks = Collective::Api::Task.all({ 'uprn' => 10024036847, 'schedule_start'=> "#{date_2_weeks_ago},#{DateTime.now.iso8601}", 'include_related' => "true" })
    tasks = Collective::Api::Task.all({ 'uprn' => 100080140483, 'schedule_start'=> "#{date_2_weeks_ago},#{DateTime.now.iso8601}", 'include_related' => "true" })
    puts "Tasks total = #{tasks.size}"
    expect(tasks.size).not_to equal(1000)
  end

  it "gets child premises" do
    items = Collective::Api::Site.all({ ParentUPRN: 100080140483 })
    puts "Items = #{items.size}"
  end

  it "gets a task" do
    task = Collective::Api::Task.find(20)
    # puts task.class
    expect(task.id.to_i).to eq(20)
  end

  it "gets a list of past tasks" do
    #TODO: hide case conversion
    date_2_weeks_ago = DateTime.parse((Time.now - TWO_WEEKS).to_s)
    puts date_2_weeks_ago
    tasks = Collective::Api::Task.all({'UPRN'=> 10024036848, 'schedule_start'=> "#{date_2_weeks_ago},#{DateTime.now.iso8601}", 'Jobs_Bounds'=>''})
    puts tasks[0].name
    puts tasks[0].location
  end

  it "gets a list of future tasks" do
    #TODO: hide case conversion
    date_2_weeks_ahead = DateTime.parse((Time.now + TWO_WEEKS).to_s)
    tasks = Collective::Api::Task.all({'UPRN'=> 10024036848, 'schedule_start'=> "#{DateTime.now.iso8601},#{date_2_weeks_ahead}", 'Jobs_Bounds'=>''})
    puts "tasks count = #{tasks.count}"
    tasks.each {|t| puts t.name}
    # puts tasks[0].name
    # puts tasks[0].location
  end

end


# 10024036847