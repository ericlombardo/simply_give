require_relative './simply_give.rb'

class SimplyGive::CLI   # interacts with the user
  attr_accessor :cause_num, :charities, :charity_num
  
  def call
    greet_user
    ask_for_cause
    ask_for_charity
  end
  
  def greet_user
    puts "Weclcome to Simply Give!"
  end
  
  def ask_for_cause
    puts "What cause would you like to view?"
    get_causes_from_api
    display_cause_names
    get_cause_input_number
  end
  
  def ask_for_charity # displays instances of charities within cause, prompts answer, gets input until valid?
    puts "These charities contribute to #{SimplyGive::Cause.all[@cause_num - 1].name}. Select which you would like to review."
    display_charity_names
    get_charity_input_number
    display_charity_info
  end
  
  def display_cause_names # show numbered list of cause names that are instances
    SimplyGive::Cause.all.each.with_index(1) {|c, i| puts "#{i}. #{c.name}"}
  end
  
  def display_charity_names
    @charities = get_charities_from_api["organizations"]
    @charities["organization"].each.with_index(1) do |org, ind|
      puts "#{ind}. #{org["name"]}"
    end
    puts "#{@charities["organization"].count + 1}. See More Charities" if @charities["hasNext"] == "true"
  end

  def display_charity_info
    binding.pry
  end

  def get_cause_input_number
    @cause_num = gets.strip.to_i   # gets input
    @cause_num.between?(1, total_causes) ? @cause_num : ask_for_cause  # ask_for_cause until match, return input when it does
  end

  def get_charity_input_number
    @charity_num = gets.strip.to_i   # gets input
    @charity_num.between?(1, @charities["organization"].count + 1) ? @charity_num : ask_for_charity
  end
  
  def total_causes   # Gets length of all array in Cause class (1 dot rule)
    SimplyGive::Cause.all.count
  end

  def get_causes_from_api   
    @causes = SimplyGive::API.new.get_causes
  end

  def get_charities_from_api
    @charities = SimplyGive::API.new.get_charities(cause_num: @cause_num - 1)
  end 
end