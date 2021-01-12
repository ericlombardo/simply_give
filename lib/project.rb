class SimplyGive::Project
  attr_accessor :name, :description, :status, :region, :goal, :funds_raised,
  :progress_report, :project_link, :start_date, :charity, :causes 
  

  @@all = []
  def initialize(name:)
    @name = name
    @causes = []
    save
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  # def self.find_by_name(query)# takes a string argument called query                      USED DURING ASSESSMENT
  #   # iterate through all project
  #   results = self.all.select do |project|
  #     project.name.downcase.include?(query.downcase) || project.charity.name.downcase.include?(query.downcase) # search for name(query) to match
  #   end
  #   binding.pry
  #   # it should return an array of all project instances whose name includes the query
  #   # if "Horse" is the query, then the return array should include
  #   # [#<Project @name="Make the Horse Smile">, #<Project @name="Pet the Horses">...]
  # end 

end

