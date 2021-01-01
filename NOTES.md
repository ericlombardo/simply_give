1. Plan your gem, imagine your interface
2. Start with the project structure - google
3. Start with the entry point - the file run
4. Force that to build the CLI interface
5. Stub out the interface
6. Start making things real
7. Discover objects
8. Program

- A Command Line Interface for showcasing causes and charities that user wants to support

- User types simply_give

- Hits API and creates Cause objects

- Greeted and shown list of causes
  1. environment
  2. homeless

- Ask user for input

- Hit API for Cause projects
  - Create Project for each one
    - Collect information in @name, @summary, @stats
  - Link to Cause to project
  - Create new Charity for each project's charity if not already there
    - link to this project

- Display all charities that have a cause that was selected
  1. Red Cross
  2. Goodwill
  3. Ronald McDonald House

- Ask user for input for what charity they would like to select

- Use input to display projects that match cause and charity selected
  1. Help others project
  2. Clean water campaign

- Ask user for input for what project they want to view

- Use input to display stats for project selected and link to make donation

- Thank user for taking the time to look at helping others


See what is brought in when you import API (all or just the 10?)
If just the ten
  see if you can get to 100
    create instances of charities for each
    collect info 
    display name
    give next page option at end
    if next page is chosen
      hit API for next
      repeat process until no more pages
  loop through and create instances of each charity for cause
Create all instances and see how long that takes for largest cause

Get All vetted orgs https://api.globalgiving.org/api/public/orgservice/all/organizations/vetted
  add parameters of theme at the end after key
  &theme=children
  go to next parameter using nextOrgId at top of results
  &nextOrgId=335


- Go through at end and check if attr_accessors should be just read or just write

