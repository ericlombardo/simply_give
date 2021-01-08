require_relative './simply_give.rb'

class SimplyGive::Cause
  attr_accessor :id, :name

  @@all = []
  def initialize(id:, name:)  # keyword args to identify in future
    @id = id
    @name = name
    @projects = [] 
    save
  end

  def self.all  
    @@all
  end
  
  def save 
    self.class.all << self
  end
end

