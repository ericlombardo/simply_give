require_relative './simply_give.rb'

class SimplyGive::Cause
  attr_accessor :name, :id

  @@all = []
  # set up charities class variable to keep track of all charities that belongs cause
  def initialize(id:, name:)  # using keyword arguments to help future programmers
    @name = name
    @id = id
    save
  end

  def self.all  # getter method for array of all causes created
    @@all
  end

  def save # saves new cause to the @@all array
    self.class.all << self
  end
end