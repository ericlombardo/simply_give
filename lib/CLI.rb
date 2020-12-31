require_relative './simply_give.rb'

class SimplyGive::CLI   # interacts with the user
  def call
    greet_user
    display_options
  end

  def greet_user
    system("clear")
    puts "Weclcome to Simply Give!"
    sleep(3)
  end

  def display_options
    system("clear")
    puts "You're one step away from simply giving to a project that you believe in."
    puts "You can help fund a project by selecting one of the following."
    puts "1. List causes"
    puts "2. Search by country"
    puts "3. Search by state"
    puts "4. Search by zip-code"
  end
end