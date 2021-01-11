require_relative '../config/environment.rb'

class SimplyGive::Charity
  attr_accessor :name, :state, :country, :mission, :url # creates attr_accessor to be assigned when they come in later

  @@all = []
  def initialize(name:)   # initialized with a name and saved to all array
    @name = name  
    save
  end

  def self.all  # getter method for all array
    @@all
  end

  def self.clear  # clears all array if needed
    @@all.clear
  end

  def save  # saves instance to all array
    self.class.all << self
  end
end

