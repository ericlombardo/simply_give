require_relative './simply_give.rb'

class SimplyGive::Project
  attr_accessor :name, :description, :status, :region, :goal, :funds_raised,
  :progress_report, :project_link, :start_date, :charity, :causes 
  # testing functionality without these :org_country, :org_mission, :causes, :org_url

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

  def self.clear
    @@all.clear
  end
end

