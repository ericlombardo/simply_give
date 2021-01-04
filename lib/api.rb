require_relative './simply_give.rb'
require 'httparty'

class SimplyGive::API < SimplyGive::APIKey  # interact with the API
  def get_causes
    response = HTTParty.get("https://api.globalgiving.org/api/public/projectservice/themes?api_key=" + api_key)
    themes = response["themes"].values.flatten # this gives you back an array of hashes with "id" and "name"
    create_causes(themes)
  end

  def create_causes(themes)   # not making instance variable until creating instances of each cause
    themes.each do |theme| # passing 1 hash with 'id' and 'name' to create instance
      id = theme.values[0]
      name = theme.values[1]
      SimplyGive::Cause.new(id: id, name: name) 
    end
  end

  def get_projects(cause)      
    binding.pry
    response = HTTParty.get("https://api.globalgiving.org/api/public/projectservice/#{cause.id}/projects/active" + api_key)
    SimplyGive::Charity.create_from_api(response)
  end
end



