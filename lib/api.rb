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
    themes.each do |theme| # passing 1 hash with 'id' and 'name'
      id = theme.values[0]
      name = theme.values[1]
      SimplyGive::Cause.new(id: id, name: name)
    end
    #=> instances all instances of Cause class 
  end

  def get_charities 
    # hit API to get charities with chosen cause
    # get response into here with data
    # create charity instances for each of the charities
    # create instance variables for data needed i.e. @name, @date_created, ect.
    # link to cause instance that was chosen
  end
end


# themes.each do |theme|    outputs the theme name
  # puts theme.values[1]
# end
