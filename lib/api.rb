require_relative './simply_give.rb'
require 'httparty'

class SimplyGive::API   # interact with the API
  def get_causes
    response = HTTParty.get("https://api.globalgiving.org/api/public/projectservice/themes?api_key=")
    themes = response["themes"].values.flatten # this gives you back an array of hashes with "id" and "name"
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

  def get_charities(cause)
    binding.pry
    response = HTTParty.get("https://api.globalgiving.org/api/public/orgservice/all/organizations/vetted?api_key=&theme=" + "#{cause.id}")
    response["organizations"]["organization"].select do |org|
      SimplyGive::Charity.new(org["name"]).tap { |charity| 
        charity.country = org["country"]
        charity.mission = org["mission"]
        charity.url = org["url"]}
   

    end
    # mission = response["organizations"]["organization"][0]["mission"].split(/[."]/)[2]
    # other_causes = response["organizations"]["organization"][0]["themes"]["theme"][0].values[1] this gets the first cause must loop through each one
  end
end


