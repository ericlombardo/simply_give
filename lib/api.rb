require_relative './simply_give.rb'
require 'httparty'
require 'json'

class SimplyGive::API   # interact with the API
  def get_causes
    # response = HTTParty.get("https://api.globalgiving.org/api/public/projectservice/themes?api_key=")
    # themes = response["themes"].values.flatten # this gives you back an array of hashes with "id" and "name"

    themes = [
      {"id"=>"animals", "name"=>"Animal Welfare"},
      {"id"=>"children", "name"=>"Child Protection"},
      {"id"=>"climate", "name"=>"Climate Action"}
    ] 
    create_causes(themes)
  end

  def create_causes(themes)   # not making instance variable until creating instances of each cause
    # takes in hash of themes, iterates through each, creates a new cause with for each one with a name and id
    
    #=> instances all instances of Cause class 
  end
end


# themes.each do |theme|    outputs the theme name
  # puts theme.values[1]
# end
