require_relative './simply_give.rb'

class SimplyGive::CLI   # interacts with the user
  attr_accessor :cause_num, :project_num, :project_set, :project
  
  def call
    greet_user
    start_from_causes
  end

  def start_from_causes
    ask_for_cause
    start_from_projects
  end

  def start_from_projects
    ask_for_project
    display_project_info
    next_steps
  end

  def greet_user
    giving_heart
    puts "             Weclcome to Simply Give!".colors                              
    puts "Where you can give to projects and charities you love." #54
    puts
    puts "                  Navigation Tips:"
    puts "    Please make screen width of image to view properly"
    puts "              * Enter 'm' to view menu"
    puts "         * Enter 'p' to view other projects"
    puts "                * Enter 'e' to exit"
    puts
    puts "  * Press 'enter' to start your Simply Give experience"
    gets.strip
  end
  
  def ask_for_cause
    get_causes_from_api if SimplyGive::Cause.all.empty?
    puts "         What cause would you like to view?"
    display_cause_names
    get_cause_input_number
  end
  
  def ask_for_project # displays instances of charities within cause, prompts answer, gets input until valid?
    @project_set = get_projects_from_api 
    puts "These projects are working to help with #{SimplyGive::Cause.all[@cause_num.to_i - 1].name}."
    puts
    display_project_names
    get_project_input_number
  end

  def display_cause_names # show numbered list of cause names that are instances
    SimplyGive::Cause.all.each.with_index(1) {|cause, ind| puts "              #{ind}. #{cause.name}"}
  end
  
  def display_project_names
    puts "Select which you would like to review. (1 - #{@project_set.count})"
    case @project_set.count
    when 0
      puts "No active projects listed for this cause."
    when 1
      puts "#{@project_set.count}. #{@project_set.name}"
    else
      @project_set.each.with_index(1) do |project, ind|
        puts "#{ind}. #{project.name}"
      end
    end
    puts "#{@project_set.count + 1}. To See More Projects" if SimplyGive::API.next_page != nil
  end

  def display_project_info
    @project = @project_set[@project_num.to_i - 1]
    puts "Charity: #{project.charity.name}"
    puts "Project: #{project.name}"    
    puts
    puts "Status: #{project.status}\nStarted: #{project.start_date}\nGoal: #{project.goal}\nRaised: #{project.funds_raised}"
    puts 
    puts "Project Description:"
    puts "#{project.description}"
    puts 
    puts "Other causes this charity supports"
    project.causes.each.with_index(1) {|cause, ind| (puts "#{ind}. #{cause.name}")}
  end
  
  def get_cause_input_number
    @cause_num = gets.strip   # gets input
    if @cause_num == "p"
      puts "Please select a cause to view projects"
      start_from_causes
    end
    check_input(@cause_num)
    @cause_num.to_i.between?(1, total_causes) ? @cause_num : start_from_causes  # ask_for_cause until match, return input when it does

  end
  
  def get_project_input_number
    @project_num = gets.strip
    check_input(@project_num)
    start_from_projects if @project_num == @project_set.count + 1
    @project_num.to_i.between?(1, @project_set.count) ? @project_num : start_from_projects
  end

  def next_steps  # Ask for next step. Go to site or back or exit
    puts "Enter 'g' to simply give or navigate to another menu"
    input = gets.strip.downcase
    check_input(input)
    if input == "g"
      system("open", project.project_link)
    end
  end

  def check_input(input) # checks for exit, causes, or projects
    input = input.downcase
    if input == "e"
      exit
    elsif input == "m"
      start_from_causes
    elsif input == "p"
   
      start_from_projects
    end
  end

  def total_causes   # Gets length of all array in Cause class 
    SimplyGive::Cause.all.count
  end
  
  def get_causes_from_api   
    SimplyGive::API.new.get_causes
  end
  
  def get_projects_from_api
    SimplyGive::API.new.get_projects(SimplyGive::Cause.all[@cause_num.to_i - 1], SimplyGive::API.next_page)
  end 

  def giving_heart
    puts "     ......................................"
    puts "     ....:kXWMMMMMNOl:  :lONMMMMMWXx:......"
    puts "     ...:l0WMMMMMMMMMXo..oXMMMMMMMMMW0l:..."
    puts "     ..:OWMMMMMMMMMMMMXOOXMMMMMMMMMMMMWO:.."
    puts "     ..:c0MMMMMMMMMMMMMMMMMMMMMMMMMMMM0c:.."
    puts "     ..:OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO:.."
    puts "     ...:dNMMMMMMMMMMMMMMMMMMMMMMMMMMXo:..."
    puts "     ....:xNMMMMMMMMMMMMMMMMMMMMMMMMXd:...."
    puts "     .....:dKWMMMMMMMMMMMMMMMMMMMMW0o:....."
    puts "     ......:cxXWMMMMMMMMMMMMMMMMWKd:......."
    puts "     ........:cxXWMMMMMMMMMMMMW0d:........."
    puts "     ..........:cdKWMMMMMMMMN0o:..........."
    puts "     ............:o0NMMMMMNOl:............."
    puts "     ..............:oONNOo:................"
    puts "     ............... :dd:.................."          
  end
end