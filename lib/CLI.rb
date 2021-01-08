require_relative '../config/environment.rb'

class SimplyGive::CLI   # interacts with the user

  attr_accessor :cause_num, :project_num, :project_set, :project
  
  API = SimplyGive::API
  CAUSE = SimplyGive::Cause
  
  def call
      welcome
      show_causes
  end       
  
  def show_causes
    get_cause
    show_projects
  end  
  
  def show_projects
    get_project
    show_project_info
  end
  
  def get_cause
    get_causes_from_api if CAUSE.all.empty?
    space
    text("SELECT WHAT CAUSE YOU ARE INTERESTED IN", :light_cyan)
    short_divider
    CAUSE.all.each.with_index(1) {|cause, ind| text("#{ind}. #{cause.name}", :light_white)}
    get_cause_input_number
  end
  
  def get_project # displays instances of charities within cause, prompts answer, gets input until valid?
    space
    @project_set = get_projects_from_api 
    text("SELECT TO SEE DETAILS OF PROJECTS THAT HELP WITH", :light_cyan)
    text("#{@cause_num}", :light_cyan)
    short_divider
    display_project_names
    get_project_input_number
  end
  
  def display_project_names
    case @project_set.count
    when 0
      text("No active projects listed for this cause.", :light_white)
    when 1
      text("#{@project_set.count}. #{@project_set.name}", :light_white)
    else
      @project_set.each.with_index(1) do |project, ind|
        text("#{ind}. #{project.name}", :light_white)
      end
    end
    text("#{@project_set.count + 1}. To See More Projects", :light_white) if API.next_page != nil
  end

  def show_project_info
    text("CHARITY:", :light_cyan)
    text("#{project.charity.name}", :light_white)
    long_divider
    text("PROJECT DESCRIPTION:", :light_cyan)
    puts "#{project.description}".colorize(:light_white)
    long_divider
    text("RAISED:", :light_cyan)
    text("$#{project.funds_raised} / $#{project.goal}", :light_white)
    long_divider
    text("ALL CAUSES THIS CHARITY SUPPORTS", :light_cyan)
    space
    @project.causes.each.with_index(1) {|cause, ind| text("#{ind}. #{cause.name}", :light_white)}
    short_divider
    next_steps
  end
  
  def get_cause_input_number
    @cause_num = gets.strip   # gets input
    if @cause_num == "p"
      text("Please select a cause to view projects", :light_white)
      show_causes
    end
    check_input(@cause_num)
    @cause_num.to_i.between?(1, total_causes) ? @cause_num = CAUSE.all[@cause_num.to_i - 1].name.upcase : show_causes  # get_cause until match, return input when it does
  end
  
  def get_project_input_number
    @project = gets.strip
    check_input(@project)
    show_projects if @project == @project_set.count + 1
    @project.to_i.between?(1, @project_set.count) ? @project = @project_set[@project.to_i - 1] : show_projects
  end

  def next_steps  # Ask for next step. Go to site or back or exit
    space
    puts "Enter ".colorize(:light_white) + "'g'".colorize(:light_red) + " to simply give".colorize(:light_white)
    input = gets.strip.downcase
    check_input(input)
    if input == "g"
      system("open", project.project_link)
    end
  end

  def check_input(input) # checks for exit, causes, or projects
    case input.downcase
    when "e"
      exit
    when "m"
      show_causes
    when "p"
      show_projects
    end
  end

  def total_causes   # Gets length of all array in Cause class 
    CAUSE.all.count
  end
  
  def get_causes_from_api   
    API.new.get_causes
  end
  
  def get_projects_from_api
    API.new.get_projects(cause: CAUSE.all[@cause_num.to_i - 1], next_page: API.next_page)
  end 

  def text(text, color)   # not using keywords to try to clean up code
    center_text = (57 - text.length) / 2
    puts " " * center_text + text.colorize(color)
  end



  # GRAPHICS AND DISPLAY PATTERNS
  # ==================================================================================
  def welcome
    border_logo   # display border to set screen size
    gets
    space
    welcome_logo
    space                                                                                                                                 
    heart_logo                                                                                          
    space    
    simply_give_logo
    sleep(4)
  end
  
  def space(count: 1)
    puts "\n" * count 
  end

  def long_divider
    space
    text("><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><", :light_red)
    space
  end

  def short_divider
    space
    text("><*><*><*><*><*><*><*><*><*><*><", :light_red)
    space
  end

  def simply_give_logo
    puts "     __ _                 _           ___ _           ".colorize(:light_white)
    puts "    / _(_)_ __ ___  _ __ | |_   _    / _ (_)_   _____ ".colorize(:light_white)
    puts "    \\"" \\""| | '_ ` _ ""\\""| '_ ""\\""| | | | |  / /_""\\""/ ""\\"" ""\\"" / / _ ""\\".colorize(:light_white)
    puts "    _""\\"" ""\\"" | | | | | | |_) | | |_| | / /_""\\""\\""| |""\\"" V /  __/".colorize(:light_white)
    puts "    \\""__/_|_| |_| |_| .__/|_|""\\""__, | ""\\""____/|_| ""\\""_/ ""\\""___|".colorize(:light_white)
    puts "                   |_|      |___/                     ".colorize(:light_white) 
  end

  def welcome_logo
    puts "   __    __     _                            ______     ".colorize(:light_white)
    puts "  / / /""\\"" ""\\"" ""\\""___| | ___ ___  _ __ ___   ___  /__  __|__  ".colorize(:light_white)
    puts "  ""\\"" ""\\""/  ""\\""/ / _ ""\\"" |/ __/ _ ""\\""| '_ ` _ ""\\"" / _ ""\\""   / / / _ ""\\"" ".colorize(:light_white)
    puts "   ""\\""  /""\\""  /  __/ | (_| (_) | | | | | |  __/  / / | (_) |".colorize(:light_white)
    puts "    ""\\""/  ""\\""/ ""\\""___|_|""\\""___""\\""___/|_| |_| |_|""\\""___|  ""\\""/   ""\\""___/ ".colorize(:light_white)
  end

  def heart_logo
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
  end

  def border_logo
    puts " .--..--..--..--..--..--..--..--..--..--..-..--..--..--.".colorize(:light_cyan)
    puts "/ .. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"". ""\\"".. ""\\"".. ""\\"".. ""\\""".colorize(:light_cyan)
    puts "\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""//""\\""/ /""\\""/ /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /`' /`' /`' /`' /`' /`' /`' /`' /`' `' /`' /""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/`--'`--'`--'`--'`--'`--'`--'`--'`--'--'`--'""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\""                                           /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                         / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                         ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                           ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\""                                           /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\".colorize(:light_cyan) + "        PLEASE MAKE SURE YOU CAN".colorize(:light_white) + "         / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /".colorize(:light_cyan) + "         SEE THE ENTIRE BOARDER".colorize(:light_white) + "          ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/".colorize(:light_cyan) +  "             FOR BEST VIEWING".colorize(:light_white) + "              ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts "\\"" " "\\""/""\\"" ""\\".colorize(:light_cyan) + "           PRESS ENTER TO START".colorize(:light_white) + "            /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                         / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                         ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                           ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\""                                           /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                         / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                         ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                           ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\""                                           /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                         / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                         ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                           ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\"".--..--..--..--..--..--..--..--..--.--..--./""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\""/ ../ ../ ../ ../ ../ ../ ../ ../ ../../ ../ /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ ""\\""/ /""\\""/ /""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/ ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `""\\"" `'""\\"" `'""\\"" `' /".colorize(:light_cyan)
    puts " `--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`-'`--'`--'`--'".colorize(:light_cyan)
  end
end