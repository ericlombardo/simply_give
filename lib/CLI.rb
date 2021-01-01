require_relative './simply_give.rb'

class SimplyGive::CLI   # interacts with the user
  def call
    greet_user
    get_causes_from_api
    ask_for_cause
  end

  def greet_user
    puts "Weclcome to Simply Give!"
  end

  def ask_for_cause
    puts "What cause would you like to view?"
    display_cause_names
    selected_cause = get_cause_from_user
  end

  def display_cause_names # show numbered list of cause names that are instances
    SimplyGive::Cause.all.each.with_index(1) {|c, i| puts "#{i}. #{c.name}"}
  end

  def get_cause_from_user
    input = gets.strip.to_i   # gets input
    input.between?(1, total_causes) ? input : ask_for_cause  # ask_for_cause until match, return input when it does
  end
  
  def total_causes   # Gets length of all array in Cause class (1 dot rule)
    SimplyGive::Cause.all.count
  end

  def get_causes_from_api   
    SimplyGive::API.new.get_causes
  end
end