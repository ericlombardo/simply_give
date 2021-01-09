require_relative '../config/environment.rb'

class SimplyGive::CLI   # interacts with the user

  attr_accessor :cause_num, :project_num, :project_set, :project, :turn_page
  
  API = SimplyGive::API
  CAUSE = SimplyGive::Cause
  
  def call
    system("clear")  
    welcome
    show_causes
  end       
  
  def show_causes
    system("clear")
    get_cause
    system("clear")
    show_projects
  end  
  
  def show_projects
    get_project
    system("clear")
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
    text("No active projects listed for this cause.", :light_white) if @project_set.count == 0

    @project_set.count == 1 ? text("1. #{@project_set[0].name}", :light_white) : 
    @project_set.each.with_index(1) {|proj, ind| text("#{ind}. #{proj.name}", :light_white)}
    
    text("#{@project_set.count + 1}. To See More Projects", :light_white) if API.next_page != nil
  end

  def show_project_info
    binding.pry
    text("CHARITY:", :light_cyan)
    text("#{project.charity.name}", :light_white)
    long_divider
    text("PROJECT DESCRIPTION:", :light_cyan)
    prj_description_formatting(text: project.description)
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
      sleep(2)
      show_causes
    end
    check_input(input: @cause_num)
    @cause_num.to_i.between?(1, total_causes) ? @cause_num = CAUSE.all[@cause_num.to_i - 1].name.upcase : show_causes  # get_cause until match, return input when it does
  end
  
  def get_project_input_number
    @project = gets.strip
    check_input(input: @project)
    system("clear") ;show_projects if @project.to_i == @project_set.count + 1
    @project.to_i.between?(1, @project_set.count) ? @project = @project_set[@project.to_i - 1] : show_projects
  end
  
  def next_steps  # Ask for next step. Go to site or back or exit
    space
    puts "Enter ".colorize(:light_white) + "'g'".colorize(:light_red) + " to simply give".colorize(:light_white)
    input = gets.strip.downcase
    check_input(input: input)
    if input == "g"
      system("open", project.project_link)
    end
  end

  def check_input(input:) # checks for exit, causes, or projects
    case input.downcase
    when "q"
      exit
    when "c"
      show_causes
    when "p"
      system("clear")
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
    width = 79
    center_text = (width - text.length) / 2
    puts " " * center_text + text.colorize(color)
  end

  def prj_description_formatting(text:)
    line = WordWrap.ww text, 59
    line = line.split("\n")
    line.each {|l| text(l, :light_white)}
  end



  # GRAPHICS AND DISPLAY PATTERNS
  # ==================================================================================
  def welcome
    border_logo  # display border to set screen size
    gets
    system("clear")
    space
    welcome_logo
    space                                                                                                                                 
    heart_logo                                                                                          
    space    
    simply_give_logo
    sleep(4)
    system("clear")
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
    text(" __ _                 _           ___ _           ", :light_white)
    text("/ _(_)_ __ ___  _ __ | |_   _    / _ (_)_   _____ ", :light_white)
    text("\\"" \\""| | '_ ` _ ""\\""| '_ ""\\""| | | | |  / /_""\\""/ ""\\"" ""\\"" / / _ ""\\", :light_white)
    text("_""\\"" ""\\"" | | | | | | |_) | | |_| | / /_""\\""\\""| |""\\"" V /  __/", :light_white)
    text("\\""__/_|_| |_| |_| .__/|_|""\\""__, | ""\\""____/|_| ""\\""_/ ""\\""___|", :light_white)
    text("               |_|      |___/                     ", :light_white)
  end

  def welcome_logo
    text(" __    __     _                            ______     ", :light_white)
    text("/ / /""\\"" ""\\"" ""\\""___| | ___ ___  _ __ ___   ___  /__  __|__  ", :light_white)
    text("""\\"" ""\\""/  ""\\""/ / _ ""\\"" |/ __/ _ ""\\""| '_ ` _ ""\\"" / _ ""\\""   / / / _ ""\\"" ", :light_white)
    text(" ""\\""  /""\\""  /  __/ | (_| (_) | | | | | |  __/  / / | (_) |", :light_white)
    text("  ""\\""/  ""\\""/ ""\\""___|_|""\\""___""\\""___/|_| |_| |_|""\\""___|  ""\\""/   ""\\""___/ ", :light_white)
  end

  def heart_logo
    puts " " * 20 + "......................................".colorize(:light_cyan)
    puts " " * 20 + ".....".colorize(:light_cyan) + ":::::::::::".colorize(:red) + "......".colorize(:light_cyan) + ":::::::::::".colorize(:red) + ".....".colorize(:light_cyan)
    puts " " * 20 + "...".colorize(:light_cyan) + "::".colorize(:red) + "kXWMMMMMMNl".colorize(:red) + "::".colorize(:red) + "..".colorize(:light_cyan) + "::".colorize(:red) + "lONMMMMMWXx".colorize(:red) + "::".colorize(:red) + "...".colorize(:light_cyan)
    puts " " * 20 + "..".colorize(:light_cyan) + "::".colorize(:red) + "l0WMMMMMMMMMXo".colorize(:red) + "::".colorize(:red) + "oXMMMMMMMMMW0l".colorize(:red) + "::".colorize(:red) + "..".colorize(:light_cyan)
    puts " " * 20 + ".".colorize(:light_cyan) + "::".colorize(:red) + "OWMMMMMMMMMMMMXOOXMMMMMMMMMMMMWO".colorize(:red) + "::".colorize(:red) + ".".colorize(:light_cyan)
    puts " " * 20 + ".".colorize(:light_cyan) + "::".colorize(:red) + "c0MMMMMMMMMMMMMMMMMMMMMMMMMMMM0c".colorize(:red) + "::".colorize(:red) + ".".colorize(:light_cyan)
    puts " " * 20 + ".".colorize(:light_cyan) + "::".colorize(:red) + "OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO".colorize(:red) + "::".colorize(:red) + ".".colorize(:light_cyan)
    puts " " * 20 + "..".colorize(:light_cyan) + "::".colorize(:red) + "dNMMMMMMMMMMMMMMMMMMMMMMMMMMXo".colorize(:red) + "::".colorize(:red) + "..".colorize(:light_cyan)
    puts " " * 20 + "...".colorize(:light_cyan) + "::".colorize(:red) + "xNMMMMMMMMMMMMMMMMMMMMMMMMXd".colorize(:red) + "::".colorize(:red) + "...".colorize(:light_cyan)
    puts " " * 20 + "....".colorize(:light_cyan) + "::".colorize(:red) + "dKWMMMMMMMMMMMMMMMMMMMMW0o".colorize(:red) + "::".colorize(:red) + "....".colorize(:light_cyan)
    puts " " * 20 + ".....".colorize(:light_cyan) + "::".colorize(:red) + "cxXWMMMMMMMMMMMMMMMMWKd".colorize(:red) + "::".colorize(:red) + "......".colorize(:light_cyan)
    puts " " * 20 + ".......".colorize(:light_cyan) + "::".colorize(:red) + "cxXWMMMMMMMMMMMMW0d".colorize(:red) + "::".colorize(:red) + "........".colorize(:light_cyan)
    puts " " * 20 + ".........".colorize(:light_cyan) + "::".colorize(:red) + "cdKWMMMMMMMMN0o".colorize(:red) + "::".colorize(:red) + "..........".colorize(:light_cyan)
    puts " " * 20 + "...........".colorize(:light_cyan) + "::".colorize(:red) + "o0NMMMMMNOl".colorize(:red) + "::".colorize(:red) + "............".colorize(:light_cyan)
    puts " " * 20 + ".............".colorize(:light_cyan) + "::".colorize(:red) + "oONNOo".colorize(:red) + "::".colorize(:red) + "...............".colorize(:light_cyan)
    puts " " * 20 + "...............".colorize(:light_cyan) + "::".colorize(:red) + "dd".colorize(:red) + "::".colorize(:red) + ".................".colorize(:light_cyan)
    puts " " * 20 + ".................".colorize(:light_cyan) + "::".colorize(:red) + "...................".colorize(:light_cyan)
    puts " " * 20 + "......................................".colorize(:light_cyan) 
  end

  def border_logo
    puts " .--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--.".colorize(:light_cyan)
    puts "/ .. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\"".. ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\""                                                                /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                                              / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                                              ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                                                ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\""                                                                /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                                              / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /".colorize(:light_cyan) + "                  PLEASE ADJUST SCREEN SIZE".colorize(:light_white) + "                   ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/".colorize(:light_cyan) + "                      TO FIT ENTIRE BORDER".colorize(:light_white) + "                      ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\".colorize(:light_cyan) + "                  BEFORE STARTING THE PROGRAM".colorize(:light_white) + "                   /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                                              / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                                              ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                                                ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\".colorize(:light_cyan) + "                        NAVIGATION TIPS:".colorize(:light_white) + "                        /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\".colorize(:light_cyan) + "               ENTER NUMBER TO MAKE SELECTION".colorize(:light_white) + "                 / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /".colorize(:light_cyan) + "                 BACK TO CAUSES => ENTER 'C'".colorize(:light_white) + "                  ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/".colorize(:light_cyan) + "                 BACK TO PROJECTS => ENTER 'P'".colorize(:light_white) + "                  ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\".colorize(:light_cyan) + "                   QUIT PROGRAM => ENTER 'Q'".colorize(:light_white) + "                    /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                                              / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                                              ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                                                ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\".colorize(:light_cyan) + "                   PRESS 'ENTER' TO CONTINUE".colorize(:light_white) + "                    /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                                              / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                                              ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                                                ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\""                                                                /""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\"" ""\\""                                                              / /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /                                                              ""\\"" ""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/                                                                ""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" ""\\""/""\\"" ""\\"".--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--./""\\"" ""\\""/ /".colorize(:light_cyan)
    puts " ""\\""/ /""\\""/ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ /""\\""/ /".colorize(:light_cyan)
    puts " / /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""/ /""\\""".colorize(:light_cyan)
    puts "/ /""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""/""\\"" ""\\""".colorize(:light_cyan)
    puts """\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `'""\\"" `' /".colorize(:light_cyan)
    puts " `--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'".colorize(:light_cyan)
  end
end