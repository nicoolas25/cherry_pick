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
#
# Load what you need to get your AR models!
#

require "./config/evironment.rb"
Rails.application.eager_load!

#
# Use your database.yml
#

require "erb"
require "yaml"

renderer = ERB.new(File.read("./config/database.yml"))
database_configs = YAML::load(renderer.result())

#
# Declare the database where the data has to be picked
#

source_db database_configs["production"]

#
# Setup the target where the data has to be imported
#

target_db database_configs["development"]

#
# The fetch block will define what to do while we're connected to the source database
#

fetch do
  # Each get will get an in-memory version of a given model and all related models
  get User.where(id: 42)

  # You can limit the exploration of the graph with the except policy
  policy max_depth: 6, except: [
    "versions",            # Don't follow any association named `versions`
    "posts/related_posts", # Don't follow `related_posts` from any `posts` association
    "comments/author/*",   # Don't follow any association after and `author` from a `comments` association
  ]

  # OR You can direct the graph using the policy with the only policy
  policy max_depth: 6, only: [
    "/posts/comments/author", # Starting from the roots, only get posts, their comments and authors
  ]
end

#
# The import block will configure how data are imported back in the targt database
#

import do
  # Each hook will run for each object saved
  before_save User do |u|
    u.password = "password"
  end
end
```

## Controlling exploration

During the traversal of the object graph, a _path_ will be attached to each object.

## TODO

- Select precisely the relations to follow
- Improve the CLI in order to specify a `get` from the command line
- Support `has_and_belongs_to_many` associations

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nicoolas25/cherry_pick.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

