require_relative './simply_give.rb'

class SimplyGive::Project
  attr_accessor :name,:description, :status, :region, :goal, :funds_raised, :donation_options,
  :progress_report, :project_link, :start_date, :most_recent_report, :charity_name, :org_country, :org_mission, :causes, :org_url

  @@all = []
  def initialize(name)
    @name = name
    @causes = []
  end

  def self.all
    @@all
  end

  def self.create_from_api(name)
    save << self.new(name)
  end

  def self.save
    @@all
  end

  def self.clear
    @@all.clear
  end
end

