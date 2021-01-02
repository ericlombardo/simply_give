require_relative './simply_give.rb'
require 'httparty'

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
    themes.each do |theme| # passing 1 hash with 'id' and 'name'
      id = theme.values[0]
      name = theme.values[1]
      SimplyGive::Cause.new(id: id, name: name)
    end
    #=> instances all instances of Cause class 
  end

  def get_charities 
    
    response = HTTParty.get("https://api.globalgiving.org/api/public/orgservice/all/organizations/vetted?api_key=3484ce94-80d5-431a-b6fc-1d85cb940ee1&theme=children")
    binding.pry
    # state = response["organizations"]["organization"][0]["state"]
    # country = response["organizations"]["organization"][0]["country"]
    # name = response["organizations"]["organization"][0]["name"]
    # mission = response["organizations"]["organization"][0]["mission"].split(/[."]/)[2]
    # other_causes = response["organizations"]["organization"][0]["themes"]["theme"][0].values[1] this gets the first cause must loop through each one
    # url = response["organizations"]["organization"][0]["url"]






    # hit API to get charities with chosen cause
    # get response into here with data
    # create charity instances for each of the charities
    # create instance variables for data needed i.e. @name, @date_created, ect.
    # link to cause instance that was chosen
  end
end


