require_relative '../config/environment.rb'    
require 'httparty'  # required for the get request to API

class SimplyGive::API
  
  URL = "https://api.globalgiving.org/api/public/projectservice/themes/"    # base url for api requests
  ACTV_PRJ = "/projects/active"                                             # filters results for only active projects
  KEY = SimplyGive::APIKey.new.api_key                                      # THIS IS WHERE YOU CALL THE METHOD THAT IS HOLDING YOUR API KEY

  @@next_page = nil   # class variable to track nextOrgId for projects

  def self.next_page  # getter method for next_page
    @@next_page
  end
  
  def get_causes      # gets causes data from API, creates new instance for each cause
    data = HTTParty.get(URL + KEY)
    cause_list = data["themes"].values.flatten    #=> array of hashes with "id" and "name"
    # iterate through hash & create instances with 'id' and 'name'
    cause_list.each {|cause| SimplyGive::Cause.new(id: cause.values[0], name: cause.values[1])}
  end

  def get_projects(cause:, next_page: nil)      # accepts cause & nextOrgId = nil, gets data from API, create charity and project instances
    full_url = URL + cause.id + ACTV_PRJ + KEY  # uses args to build the entire base url for API requests

    @@next_page == nil ? data = HTTParty.get(full_url) :          # checks @@next_page, if nil gets first set, else gets set with nextOrgId
    data = HTTParty.get(full_url + "&nextProjectId=#{@@next_page}")

    data["projects"]["hasNext"] == "true" ?                       # assigns @@next_page variable according to hasNext value
    @@next_page = data["projects"]["nextProjectId"] : nil
                           
    project_set = []
 
    data["projects"]["project"].each do |prj|             # iterates through each project
      causes = prj["organization"]["themes"]["theme"]     # drills down to causes level, #=> hash of 'id' and 'name'
      
      n_prj = SimplyGive::Project.new(name: prj["title"]) # create and assign values for each project
      n_prj.description = prj["summary"]
      n_prj.status = prj["status"]
      n_prj.goal = prj["goal"]
      n_prj.funds_raised = prj["funding"]
      n_prj.project_link = prj["projectLink"]

      n_prj.charity = SimplyGive::Charity.new(name: prj["organization"]["name"]).tap do |org|   # create and assign values for charity
        org.state = prj["organization"]["state"]
        org.country = prj["organization"]["country"]
        org.mission = prj["organization"]["mission"]
        org.url = prj["organization"]["url"]
      end

      SimplyGive::Cause.all.each do |cause|                       # iterates through all Cause instances
        if !causes.is_a?(Array)                                   # check if only 1 cause
          n_prj.causes << cause if cause.id == causes["id"]       # finds match, shovels instance of cause into n_prj.causes array
        else
          causes.each do |proj_cause|                             
            n_prj.causes << cause if cause.id == proj_cause["id"] # finds matches, shovels instances of cause into n_prj.causes array
          end
        end
      end
      project_set << n_prj    #=> 10 project instances each time there is an API hit
    end
    project_set
  end
end



