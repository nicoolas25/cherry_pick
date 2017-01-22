# cherry_pick

This gem aims to provide a CLI that import data from production to a local environment.

It focus Rails and ActiveRecord but it would be great to support more frameworks and ORMs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cherry_pick'
```

And then execute:

    $ bundle

## Usage

`cherry_pick` needs a configuration file that is just plain Ruby. In this configuration file
you describe both source and target environments (ie: database configurations) alongside with
the models you need to pick from the source.

``` ruby
# Load what you need to get your AR models!
require_relative "./config/application"

# Declare the database where the data has to be picked
source_db adapter: "mysql2", host: "localhost",      username: "postgres", password: "password")

# Setup the target where the data has to be imported
target_db adapter: "mysql2", host: "216.58.204.110", username: "postgres", password: "password")

# The fetch block will define what to do while we're connected to the source database
fetch do
  # Each get will get an in-memory version of a given model and all related models
  get User.where(id: 42)

  # You could also use a query to get all the object (be careful with the memory)
  get User.where("age <= ?", 30)
end

# The import block will configure how data are imported back in the targt database
import do
  # Each hook will run for each object saved
  before_save User do |u|
    u.password = "password"
  end
end
```

## Plans

- Use queries to select things to import: `get User.where("age <= ?", 30)`
- Anonymous imports: reset passwords, tokens, emails, IPs, ...

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nicoolas25/cherry_pick.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

