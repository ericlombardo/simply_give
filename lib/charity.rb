require_relative './simply_give.rb'

class SimplyGive::Charity
  attr_accessor :name, :state, :country, :mission, :causes, :url

  @@all = []
  
  def initialize(name)  # using keyword arguments to help future programmers
    @name = name
    @causes = [] # hold instances of causes
    save
  end


  def self.all  # getter method for array of all causes created
    @@all
  end

  def save # saves new cause to the @@all array
    self.class.all << self
  end

  def self.create_from_api(data)
    data["organizations"]["organization"].collect do |org|
      charity = self.new(org["name"])
      charity.state = org["state"]
      charity.country = org["country"]
      charity.mission = org["mission"]
      charity.url = org["url"]
      charity_causes = Array.try_convert(org["themes"]["theme"]) == nil ? org["themes"]["theme"]["name"] : org["themes"]["theme"].collect {|t| t["name"]}
      charity.causes = (charity.causes + SimplyGive::Cause.all.find_all {|cause| charity_causes.include?(cause.name)}).uniq
    end
  end

end

# data["organizations"]["organization"][7]["themes"]["theme"] this is to the start of an array of hashes or a hash if it is single