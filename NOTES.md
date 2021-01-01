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



- Go through at end and check if attr_accessors should be just read or just write

