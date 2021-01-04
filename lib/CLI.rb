require_relative './simply_give.rb'

class SimplyGive::CLI   # interacts with the user
  attr_accessor :cause_num, :charity_num
  
  def call
    greet_user
    ask_for_cause
    ask_for_projects
  end
  
  def greet_user
    puts "Weclcome to Simply Give! Where you can give to projects and charities you love."
  end
  
  def ask_for_cause
    puts "What cause would you like to view?"
    get_causes_from_api if SimplyGive::Cause.all.empty?
    display_cause_names
    get_cause_input_number
  end
  
  def ask_for_projects # displays instances of charities within cause, prompts answer, gets input until valid?
    puts "These projects are working to help with #{SimplyGive::Cause.all[@cause_num - 1].name}. \nSelect which you would like to review."
    display_project_names
    get_charity_input_number
  end
  
  def display_cause_names # show numbered list of cause names that are instances
    SimplyGive::Cause.all.each.with_index(1) {|cause, ind| puts "#{ind}. #{cause.name}"}
  end
  
  def display_project_names
    get_projects_from_api
    SimplyGive::Charity.all.each.with_index(1) do |project, ind|
      puts "#{ind}. #{charity.name}"
    end
  end
  
  def get_cause_input_number
    @cause_num = gets.strip.to_i   # gets input
    @cause_num.between?(1, total_causes) ? @cause_num : ask_for_cause  # ask_for_cause until match, return input when it does
  end
  
  def get_charity_input_number
    @charity_num = gets.strip.to_i 
  end
  
  def total_causes   # Gets length of all array in Cause class (1 dot rule)
    SimplyGive::Cause.all.count
  end
  
  def get_causes_from_api   
    SimplyGive::API.new.get_causes
  end
  
  def get_projects_from_api
    binding.pry
    SimplyGive::API.new.get_projects(SimplyGive::Cause.all[@cause_num - 1])
  end 
end