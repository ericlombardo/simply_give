require_relative '../config/environment.rb'

class SimplyGive::Charity
  attr_accessor :name, :state, :country, :mission, :url

  @@all = []
  def initialize(name:) 
    @name = name 
    save
  end

  def self.all  
    @@all
  end

  def self.clear
    @@all.clear
  end

  def save 
    self.class.all << self
  end
end

