require_relative './simply_give.rb'

class SimplyGive::CLI   # interacts with the user
  attr_accessor :cause_num, :project_num, :project_set
  
  def call
    greet_user
    ask_for_cause
    ask_for_project
    display_project_info
  end
  
  def greet_user
    puts "             Weclcome to Simply Give!"                              
    puts "Where you can give to projects and charities you love." # 26 half way
    puts
    get_causes_from_api if SimplyGive::Cause.all.empty?
    sleep(4)
  end
  
  def ask_for_cause
    puts "         What cause would you like to view?" # 17
    puts
    display_cause_names
    get_cause_input_number
  end
  
  def ask_for_project # displays instances of charities within cause, prompts answer, gets input until valid?
    @project_set = get_projects_from_api 
    puts "These projects are working to help with #{SimplyGive::Cause.all[@cause_num - 1].name}."
    puts
    display_project_names
    get_project_input_number
  end

  def display_cause_names # show numbered list of cause names that are instances
    binding.pry
    SimplyGive::Cause.all.each.with_index(1) {|cause, ind| puts "              #{ind}. #{cause.name}"}
  end
  
  def display_project_names
    puts "Select which you would like to review. (1 - #{@project_set.count})"
    case @project_set.count
    when 0
      puts "No active projects listed for this cause."
    when 1
      puts "#{@project_set.count}. #{@project_set.name}"
    else
      @project_set.each.with_index(1) do |project, ind|
        puts "#{ind}. #{project.name}"
      end
    end
    puts "#{@project_set.count + 1}. To See More Projects" if SimplyGive::API.next_page != nil
  end

  def display_project_info
    project = @project_set[@project_num - 1]
    puts "Charity: #{project.charity.name}"
    puts "Project: #{project.name}"    
    puts
    puts "Status: #{project.status}\nStarted: #{project.start_date}\nGoal: #{project.goal}\nRaised: #{project.funds_raised}"
    puts 
    puts "Project Description:"
    puts "#{project.description}"
    puts 
    puts "Other causes this charity supports"
    project.causes.each.with_index(1) {|cause, ind| (puts "#{ind}. #{cause.name}")}
    puts "Simply Give to this project by clicking the link below"
    puts project.project_link
  end
  
  def get_cause_input_number
    @cause_num = gets.strip.to_i   # gets input
    @cause_num.between?(1, total_causes) ? @cause_num : ask_for_cause  # ask_for_cause until match, return input when it does
  end
  
  def get_project_input_number
    @project_num = gets.strip.to_i
    if @project_num == @project_set.count + 1
      ask_for_project
    elsif @project_num.between?(1, @project_set.count + 1)
      @project_num
    else
      display_project_names
      get_project_input_number
    end
    # if @project_num == @project_set.count + 1
  end

  def total_causes   # Gets length of all array in Cause class 
    SimplyGive::Cause.all.count
  end
  
  def get_causes_from_api   
    SimplyGive::API.new.get_causes
  end
  
  def get_projects_from_api
    SimplyGive::API.new.get_projects(SimplyGive::Cause.all[@cause_num - 1], SimplyGive::API.next_page)
  end 
end