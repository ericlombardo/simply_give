require_relative './simply_give.rb'
require 'httparty'
require 'json'

class SimplyGive::API   # interact with the API
  def get_causes
    response = HTTParty.get("https://api.globalgiving.org/api/public/projectservice/themes?api_key=")
    # binding.pry
    response["themes"].values # this gives you back an array of hashes with "id" and "name"
  end
end