require_relative './simply_give.rb'

class SimplyGive::CLI   # interacts with the user
  def call
    greet_user
    display_options
  end

  def greet_user
    puts "Weclcome to Simply Give!"
  end

  def display_options
    puts "What cause would you like to give to?"
    list_causes
  end

  def display_causes
    SimplyGive::API.new.get_causes.each.with_index(1) do |cause, index|
      puts "#{index}. #{cause}"
    end
  end
end