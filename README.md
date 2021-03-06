# SimplyGive

Simply Give was designed to help people who want to give to causes that they beleive in,
but don't know where to start. This program aims to solves that problem by providing a
user friendly interface with access to thousands of projects that charities
are currently working on. When you find a project or charity that speaks to you,
you are taken directly to the project site (on Global Giving website) or directly to the
charity's website where you Simply Give to the cause.

## Installation

* Clone the git repository onto your computer


* Get an API key from Global Giving (https://www.globalgiving.org/api/)


* Put your API key in lib/api_key.rb inside the method and save
   
   ![](lib/images/api_key.png)
    

Go to the command line and execute:

    $ bundle install
    
Once there, run program by executing:

    $ ./bin/simply_give

## Usage

Upon launching the program you will be prompted to adjust the screen to the optimal size to make sure you can see the edges of the border. 

![](lib/images/border.png)

After this, the program starts and you are able to view projects by selecting a cause. After you have entered a cause you are interested in, you are able to jump back to the main menu and select a different cause to look into. You may need to scroll to see some of the content of the projects depending on the length of the descriptions. 

## Build Status
While Simply Give is up and fully functional, there are features that I would like to incorporate in the future. I would like to include a way to search by regions, track donations in an external file, and create person instances to expand the usability of the program.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ericlombardo/simply_give. 
Please review the [Contributing Guidelines](https://github.com/ericlombardo/simply_give/blob/master/CONTRIBUTING.md) to make sure everyone is following the proper formating.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimplyGive project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ericlombardo/simply_give/blob/master/CODE_OF_CONDUCT.md).

## Attribution

The API used in this program was from Global Giving and can be found at: https://www.globalgiving.org/

