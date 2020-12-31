require_relative './simply_give.rb'

class SimplyGive::API   # interact with the API
  attr_accessor :causes, :projects
  
  def get_causes
    @causes = %w[animals children climate democ disaster ecdev edu env gender]
  end

  def

  def get_projects
    @projects = %w[]
  end

  def get_organizations

  end
end