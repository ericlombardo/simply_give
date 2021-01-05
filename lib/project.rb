require_relative './simply_give.rb'

class SimplyGive::Project
  attr_accessor :name 

  @@all = []
  def initialize(name)
    @name = name
  end

  def self.all
    @@all
  end

  def create(name)
    binding.pry
    self.class.new(name)
    save << self
  end

  def self.save
    @@all
  end
end


# description, org name, region, let them know it is active, goal, location, partnership, gift giving amounts, volunteer opportunities, progress report link, videos
# additional documentation, start date(break at - (but check if all the same)), country, date of most recent report, last modified, donation options, goal, funding
# org name, country, mission, causes(link to instance.name), url, 