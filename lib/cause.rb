require_relative './simply_give.rb'

class SimplyGive::Cause
  attr_accessor :name, :id, :charities

  @@all = []
  def initialize(id:, name:)  # using keyword arguments to help future programmers
    @name = name
    @id = id
    @charities = [] 
    save
  end

  def self.all  # getter method for array of all causes created
    @@all
  end
  
  def save # saves new cause to the @@all array
    self.class.all << self
  end
end

