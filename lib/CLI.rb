require_relative '../config/environment.rb'

class SimplyGive::CLI   # interacts with the user
  attr_accessor :cause_name, :project_set, :project, :turn_page

  API = SimplyGive::API       # creates CONSTANTS for API and CAUSE 
  CAUSE = SimplyGive::Cause   # to avoid puttting SimplyGive module each time
  
  def start
    system("clear")   # clears system to start 
    border_logo       # display border to set screen size
    gets              # waits for user to start program
    system("clear")   
    welcome_screen    # Welcomes user to Simply Give
    get_cause         # launch next method
  end

  def get_cause
    API.new.get_causes if CAUSE.all.empty?            # sends get request if not already done
    title("SELECT WHAT CAUSE YOU ARE INTERESTED IN")  # display title for user
    CAUSE.all.each.with_index(1) {|c, ind| text("#{ind}. #{c.name}", :light_white)}   # lists out each cause
    get_cause_input_number    # executes next method
  end

  def get_cause_input_number
    @cause_name = gets.strip   # accepts user input
    
    if @cause_name == "p"      # checks for invalid menus selection 
      text("Please select a cause to view projects", :light_red)  # alerts user of how to handle invalid input
      sleep(2) ;system("clear") ;get_cause    # pauses, clears and sends user back to cause menu
    end

    system("clear") ;get_cause until 
      nav_check(input: @cause_name) || @cause_name.to_i.between?(1, total_causes)    # loops until valid input
    get_project   # executes next method
  end

  def get_project # gets projects within a certain cause from the API
    system("clear")
    @project_set = get_projects_from_api    # assigns 10 instances of projects to this array with names, ect.
    display_project_names   # executes next method
  end
  
  def display_project_names   
    title("THESE PROJECTS HELP WITH #{cause_name}")   # title displayed for user

    text("No active projects listed for this cause.", :light_white) if @project_set.count == 0 # checks for no projects

    if @project_set.count == 1    # checks if only 1 project
      text("1. #{@project_set[0].name}", :light_white)    # prints project if so
    else 
      @project_set.each.with_index(1) {|proj, ind| text("#{ind}. #{proj.name}", :light_white)}    # iterates through and puts
    end
    
    text("#{@project_set.count + 1}. See More Projects", :light_white) if API.next_page != nil   # puts See More if there is another page
    get_project_input_number    # executes next method
  end
  
  def get_project_input_number
    @project = gets.strip   # gets input from user
    nav_check(input: @project)  # checks for navigation commands
    get_project if @project.to_i == @project_set.count + 1    # gets next page if the user asks for See More
    system("clear") ;display_project_names until @project.to_i.between?(1, @project_set.count)  # loops until valid input
    @project = @project_set[@project.to_i - 1]  # assigns user selected input to #project variable
    show_project_info   # executes nex method
  end

  def show_project_info   # display all info for project
    system("clear")
    long_divider  # graphic divider
    text("CHARITY", :light_cyan)  
    text("#{project.charity.name}", :light_white)
    long_divider
    text("PROJECT DESCRIPTION:", :light_cyan)
    prj_descr_format(text: project.description)
    long_divider
    text("RAISED:", :light_cyan)
    text("$#{project.funds_raised} / $#{project.goal}", :light_white)
    long_divider
    text("ALL CAUSES THIS CHARITY SUPPORTS", :light_cyan)
    space
    @project.causes.each.with_index(1) {|cause, ind| text("#{ind}. #{cause.name}", :light_white)} # interates through to put causes
    next_steps  # executes next method
  end
  
  def next_steps  # Ask if user wants to go to websites or navigate somewhere else
    long_divider
    text("READY TO SIMPLY GIVE TO THIS PROJECT/CAUSE?", :light_yellow)
    space
    text("1. GO TO PROJECT SITE TO DONATE", :light_yellow)
    text("2. GO DIRECTLY TO CHARITY SITE TO DONATE", :light_yellow)
    input = gets.strip.downcase
    nav_check(input: input)
    show_project_info until input.to_i.between?(1, 2)
    input.to_i == 1 ? Launchy.open(project.project_link) : Launchy.open(project.charity.url) # uses input to navigate to menus or launch websites
    system("clear") 
    long_divider
    prj_descr_format(text: "WE ARE REROUTING YOU TO YOUR DESIRED SITE. MAKE SURE TO COME BACK AND CHECK OUT SOME MORE PROJECTS WHEN YOU'RE DONE")
    long_divider
    sleep(10)
    system("clear")
    display_project_names   # displays projects for user to view when they are done one the website
  end

  def nav_check(input:) # checks input for navigation to other menus or websites
    case input.downcase
    when "q"
      system("clear")
      short_divider
      text("THANK YOU FOR USING SIMPLY GIVE. HAVE A BLESSED DAY!", :light_cyan)
      short_divider
      sleep(3)
      exit
    when "c"
      system("clear")
      get_cause
    when "p"
      system("clear") 
      display_project_names
    end
  end

  def total_causes   # Gets length of all array in Cause class 
    CAUSE.all.count
  end
  
  def cause_name
    CAUSE.all[@cause_name.to_i - 1].name.upcase
  end

  def get_projects_from_api
    API.new.get_projects(cause: CAUSE.all[@cause_name.to_i - 1], next_page: API.next_page)
  end 

  def text(text, color = :light_white)   
    width = 79
    center_text = (width - text.length) / 2
    puts " " * center_text + text.colorize(color)
  end

  def prj_descr_format(text:)
    line = WordWrap.ww text, 59
    line.split("\n").each {|l| text(l, :light_white)}
  end

  # GRAPHICS AND DISPLAY PATTERNS
  # ==================================================================================
  def space(count: 1) # allows me to put any variation of spaces I need instead of having to use puts each time
    puts "\n" * count 
  end

  def long_divider  # puts a red divider with spaces on top bottom in
    space
    text("><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><", :light_red)
    space
  end

  def short_divider # puts a red divider with spaces on top bottom in
    space
    text("><*><*><*><*><*><*><*><*><*><*><", :light_red)
    space
  end

  def welcome_screen  # logic for displaying welcome sequence
    space
    welcome_logo
    space                                                                                                                                 
    heart_logo                                                                                          
    space    
    simply_give_logo
    sleep(4)
    system("clear")
  end

  def title(title)  # sets template for title layouts to be called throughout
    short_divider
    text(title, :light_cyan)
    short_divider
  end

  def simply_give_logo  # 'Simply Give Ascii art logo'
    text(" __ _                 _           ___ _           ", :light_white)
    text("/ _(_)_ __ ___  _ __ | |_   _    / _ (_)_   _____ ", :light_white)
    text("\\"" \\""| | '_ ` _ ""\\""| '_ ""\\""| | | | |  / /_""\\""/ ""\\"" ""\\"" / / _ ""\\", :light_white)
    text("_""\\"" ""\\"" | | | | | | |_) | | |_| | / /_""\\""\\""| |""\\"" V /  __/", :light_white)
    text("\\""__/_|_| |_| |_| .__/|_|""\\""__, | ""\\""____/|_| ""\\""_/ ""\\""___|", :light_white)
    text("               |_|      |___/                     ", :light_white)
  end

  def welcome_logo  # 'Welcome To Ascii art logo'
    text(" __    __     _                            ______     ", :light_white)
    text("/ / /""\\"" ""\\"" ""\\""___| | ___ ___  _ __ ___   ___  /__  __|__  ", :light_white)
    text("""\\"" ""\\""/  ""\\""/ / _ ""\\"" |/ __/ _ ""\\""| '_ ` _ ""\\"" / _ ""\\""   / / / _ ""\\"" ", :light_white)
    text(" ""\\""  /""\\""  /  __/ | (_| (_) | | | | | |  __/  / / | (_) |", :light_white)
    text("  ""\\""/  ""\\""/ ""\\""___|_|""\\""___""\\""___/|_| |_| |_|""\\""___|  ""\\""/   ""\\""___/ ", :light_white)
  end

  def heart_logo    # heart logo in Ascii art
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

  def border_logo   # sizing border
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