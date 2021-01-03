require_relative './simply_give.rb'

class SimplyGive::Charity
  attr_accessor :name, :country, :mission, :other_causes, :url

  @@all = []
  @@causes = [] # set up cause class variable to collect all the causes that a charity contributes to
  def initialize(name)  # using keyword arguments to help future programmers
    @name = name
    save
  end

  def self.all  # getter method for array of all causes created
    @@all
  end

  def self.causes
    @@causes
  end

  def save # saves new cause to the @@all array
    self.class.all << self
  end
end