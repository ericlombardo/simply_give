require_relative './simply_give.rb'

class SimplyGive::CLI   # interacts with the user
  attr_accessor :cause_num, :project_num, :project_set, :project
  
  def call
    welcome_screen
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
    puts
    long_divider
    puts "     __ _                 _           ___ _           ".colorize(:light_cyan)
    puts "    / _(_)_ __ ___  _ __ | |_   _    / _ (_)_   _____ ".colorize(:light_cyan)
    puts "    \\"" \\""| | '_ ` _ ""\\""| '_ ""\\""| | | | |  / /_""\\""/ ""\\"" ""\\"" / / _ ""\\".colorize(:light_cyan)
    puts "    _""\\"" ""\\"" | | | | | | |_) | | |_| | / /_""\\""\\""| |""\\"" V /  __/".colorize(:light_cyan)
    puts "    \\""__/_|_| |_| |_| .__/|_|""\\""__, | ""\\""____/|_| ""\\""_/ ""\\""___|".colorize(:light_cyan)
    puts "                   |_|      |___/                     ".colorize(:light_cyan) 
    puts                           
    puts " " * 2 + "WHERE YOU CAN GIVE TO PROJECTS AND CHARITIES YOU LOVE.".colorize(:light_white) #54
    puts 
    short_divider
    puts 
    puts " " * 21 + "NAVIGATION TIPS:".colorize(:light_cyan)
    puts "              * Enter ".colorize(:light_white) + "'m'".colorize(:light_red) + " to view menu".colorize(:light_white)
    puts "         * Enter ".colorize(:light_white) + "'p'".colorize(:light_red) + " to view other projects".colorize(:light_white)
    puts "                * Enter ".colorize(:light_white) + "'e'".colorize(:light_red) + " to exit".colorize(:light_white)
    puts
    puts "  * Press 'enter' to start your Simply Give experience".colorize(:light_white)
    gets.strip
  end
  
  def ask_for_cause
    get_causes_from_api if SimplyGive::Cause.all.empty?
    puts
    puts " " * 9 + "SELECT WHAT CAUSE YOU ARE INTERESTED IN".colorize(:light_cyan)
    short_divider
    puts
    display_cause_names
    get_cause_input_number
  end
  
  def ask_for_project # displays instances of charities within cause, prompts answer, gets input until valid?
    puts " "
    binding.pry
    @project_set = get_projects_from_api 
    binding.pry
    puts "#{SimplyGive::Cause.all[@cause_num.to_i - 1].name.upcase}".colorize(:light_cyan)
    puts "SELECT TO VIEW DETAILS".colorize(:light_cyan)
    puts
    short_divider
    puts
    display_project_names
    get_project_input_number
  end

  def display_cause_names # show numbered list of cause names that are instances
    SimplyGive::Cause.all.each.with_index(1) {|cause, ind| puts "              #{ind}.".colorize(:light_red) + " #{cause.name}".colorize(:light_white)}
  end
  
  def display_project_names
    case @project_set.count
    when 0
      puts "No active projects listed for this cause.".colorize(:light_white)
    when 1
      puts "#{@project_set.count}.".colorize(:light_red) +  "#{@project_set.name}".colorize(:light_white)
    else
      @project_set.each.with_index(1) do |project, ind|
        puts "#{ind}.".colorize(:light_red) +  " #{project.name}".colorize(:light_white)
      end
    end
    puts "#{@project_set.count + 1}.".colorize(:light_red) +  " To See More Projects".colorize(:light_white) if SimplyGive::API.next_page != nil
  end

  def display_project_info
    @project = @project_set[@project_num.to_i - 1]

    puts "CHARITY:".colorize(:light_cyan) + " #{project.charity.name}".colorize(:light_white)
    puts 
    puts long_divider
    puts
    puts "PROJECT DESCRIPTION:".colorize(:light_cyan)
    puts "#{project.description}".colorize(:light_white)
    puts
    long_divider
    puts
    puts "RAISED:".colorize(:light_cyan) + " $#{project.funds_raised} / $#{project.goal}".colorize(:light_white)
    puts 
    long_divider
    puts
    puts "OTHER CAUSES THIS CHARITY SUPPORTS".colorize(:light_cyan)
    puts
    long_divider
    puts
    project.causes.each.with_index(1) {|cause, ind| (puts "#{ind}.".colorize(:light_red) + " #{cause.name}".colorize(:light_white))}
    puts
  end
  
  def get_cause_input_number
    @cause_num = gets.strip   # gets input
    if @cause_num == "p"
      puts "Please select a cause to view projects".colorize(:light_white)
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
    puts
    puts "Enter ".colorize(:light_white) + "'g'".colorize(:light_red) + " to simply give".colorize(:light_white)
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

  def long_divider
    puts " " * 2 + "><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><".colorize(:light_white)
  end

  def short_divider
    puts " " * 13 + "><*><*><*><*><*><*><*><*><*><*><".colorize(:light_white)
  end

  def welcome_screen
    puts
    puts " " * 6 + "Please make window 57 x 32 for optimal viewing".colorize(:light_white)
    puts " " * 16 + "Press 'enter' to continue"
    gets.strip
    puts "   __    __     _                            ______     "
    puts "  / / /""\\"" ""\\"" ""\\""___| | ___ ___  _ __ ___   ___  /__  __|__  "
    puts "  ""\\"" ""\\""/  ""\\""/ / _ ""\\"" |/ __/ _ ""\\""| '_ ` _ ""\\"" / _ ""\\""   / / / _ ""\\"" "
    puts "   ""\\""  /""\\""  /  __/ | (_| (_) | | | | | |  __/  / / | (_) |"
    puts "    ""\\""/  ""\\""/ ""\\""___|_|""\\""___""\\""___/|_| |_| |_|""\\""___|  ""\\""/   ""\\""___/ "
    puts                                                                                                                                 
    puts "        ......................................".colorize(:light_cyan)
    puts "        .....".colorize(:light_cyan) + ":::::::::::".colorize(:red) + "......".colorize(:light_cyan) + ":::::::::::".colorize(:red) + ".....".colorize(:light_cyan)
    puts "        ...".colorize(:light_cyan) + "::".colorize(:red) + "kXWMMMMMMNl".colorize(:red) + "::".colorize(:red) + "..".colorize(:light_cyan) + "::".colorize(:red) + "lONMMMMMWXx".colorize(:red) + "::".colorize(:red) + "...".colorize(:light_cyan)
    puts "        ..".colorize(:light_cyan) + "::".colorize(:red) + "l0WMMMMMMMMMXo".colorize(:red) + "::".colorize(:red) + "oXMMMMMMMMMW0l".colorize(:red) + "::".colorize(:red) + "..".colorize(:light_cyan)
    puts "        .".colorize(:light_cyan) + "::".colorize(:red) + "OWMMMMMMMMMMMMXOOXMMMMMMMMMMMMWO".colorize(:red) + "::".colorize(:red) + ".".colorize(:light_cyan)
    puts "        .".colorize(:light_cyan) + "::".colorize(:red) + "c0MMMMMMMMMMMMMMMMMMMMMMMMMMMM0c".colorize(:red) + "::".colorize(:red) + ".".colorize(:light_cyan)
    puts "        .".colorize(:light_cyan) + "::".colorize(:red) + "OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO".colorize(:red) + "::".colorize(:red) + ".".colorize(:light_cyan)
    puts "        ..".colorize(:light_cyan) + "::".colorize(:red) + "dNMMMMMMMMMMMMMMMMMMMMMMMMMMXo".colorize(:red) + "::".colorize(:red) + "..".colorize(:light_cyan)
    puts "        ...".colorize(:light_cyan) + "::".colorize(:red) + "xNMMMMMMMMMMMMMMMMMMMMMMMMXd".colorize(:red) + "::".colorize(:red) + "...".colorize(:light_cyan)
    puts "        ....".colorize(:light_cyan) + "::".colorize(:red) + "dKWMMMMMMMMMMMMMMMMMMMMW0o".colorize(:red) + "::".colorize(:red) + "....".colorize(:light_cyan)
    puts "        .....".colorize(:light_cyan) + "::".colorize(:red) + "cxXWMMMMMMMMMMMMMMMMWKd".colorize(:red) + "::".colorize(:red) + "......".colorize(:light_cyan)
    puts "        .......".colorize(:light_cyan) + "::".colorize(:red) + "cxXWMMMMMMMMMMMMW0d".colorize(:red) + "::".colorize(:red) + "........".colorize(:light_cyan)
    puts "        .........".colorize(:light_cyan) + "::".colorize(:red) + "cdKWMMMMMMMMN0o".colorize(:red) + "::".colorize(:red) + "..........".colorize(:light_cyan)
    puts "        ...........".colorize(:light_cyan) + "::".colorize(:red) + "o0NMMMMMNOl".colorize(:red) + "::".colorize(:red) + "............".colorize(:light_cyan)
    puts "        .............".colorize(:light_cyan) + "::".colorize(:red) + "oONNOo".colorize(:red) + "::".colorize(:red) + "...............".colorize(:light_cyan)
    puts "        ...............".colorize(:light_cyan) + "::".colorize(:red) + "dd".colorize(:red) + "::".colorize(:red) + ".................".colorize(:light_cyan)
    puts "        .................".colorize(:light_cyan) + "::".colorize(:red) + "...................".colorize(:light_cyan)
    puts "        ......................................".colorize(:light_cyan)                                                                                          
    puts    
    puts "   __ _                 _           ___ _           ".colorize(:light_white)
    puts "  / _(_)_ __ ___  _ __ | |_   _    / _ (_)_   _____ ".colorize(:light_white)
    puts "  \\"" \\""| | '_ ` _ ""\\""| '_ ""\\""| | | | |  / /_""\\""/ ""\\"" ""\\"" / / _ ""\\".colorize(:light_white)
    puts "  _""\\"" ""\\"" | | | | | | |_) | | |_| | / /_""\\""\\""| |""\\"" V /  __/".colorize(:light_white)
    puts "  \\""__/_|_| |_| |_| .__/|_|""\\""__, | ""\\""____/|_| ""\\""_/ ""\\""___|".colorize(:light_white)
    puts "                 |_|      |___/                     ".colorize(:light_white)
    sleep(5)
  end
end