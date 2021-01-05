require_relative './simply_give.rb'

class SimplyGive::Charity
  attr_accessor :name, :state, :country, :mission, :causes, :url

  @@all = []
  
  def initialize(name)  # using keyword arguments to help future programmers
    @name = name # hold instances of causes
    save
  end


  def self.all  # getter method for array of all causes created
    @@all
  end

  def self.clear
    @@all.clear
  end

  def save # saves new cause to the @@all array
    self.class.all << self
  end

end

