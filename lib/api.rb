require_relative './simply_give.rb'
require 'httparty'

class SimplyGive::API < SimplyGive::APIKey  # interact with the API
  def get_causes
    response = HTTParty.get("https://api.globalgiving.org/api/public/projectservice/themes" + api_key)
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
    response = HTTParty.get("https://api.globalgiving.org/api/public/projectservice/themes/#{cause.id}/projects/active" + api_key)
    projects = response["projects"]["project"]
    projects.each do |project|
      # binding.pry
      causes = project["organization"]["themes"]["theme"]
      new_project = SimplyGive::Project.new(project["title"])
      new_project.description = project["summary"]
      new_project.status = project["status"]
      new_project.region = project["region"]
      new_project.goal = project["goal"]
      new_project.funds_raised = project["funding"]
      new_project.progress_report = project["progressReportLink"]
      new_project.project_link = project["projectLink"]
      new_project.start_date = project["approvedDate"].slice(/.{10}/)
      new_project.charity = SimplyGive::Charity.new(project["organization"]["name"]).tap do |org|
        org.state = project["organization"]["state"]
        org.country = project["organization"]["country"]
        org.mission = project["organization"]["mission"]   # dig deaper for below
        org.url = project["organization"]["url"]
      end
      # binding.pry
      SimplyGive::Cause.all.each do |cause|
        if !causes.is_a?(Array)
          new_project.causes << cause if cause.id == causes["id"]
        else
          causes.each do |proj_cause|
            new_project.causes << cause if cause.id == proj_cause["id"]
          end
        end
      end
    end
  end
end



