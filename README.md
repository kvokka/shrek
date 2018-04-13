[![Build Status](https://travis-ci.org/kvokka/shrek.svg?branch=master)](https://travis-ci.org/kvokka/shrek) 
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/248c701de3be453298cefc5b481b47a2)](https://www.codacy.com/app/kvokka/shrek?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=kvokka/shrek&amp;utm_campaign=Badge_Grade)

# Shrek

[![Shrek](https://i.imgur.com/hlXgpWR.png)](https://www.youtube.com/watch?v=GZpcwKEIRCI)


Minimalistic variation of nested builder pattern. The most popular pattern 
implementation is in `Rack::Middleware`. Extremely useful for organizing 
heavy processing and encapsulate every piece of logic.

 * Hint: perfect for achieving understanding, how Middleware works

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shrek'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shrek

## Usage

Basic structure is `Layer`. Layer is self-sufficient piece of logic, which 
in ideal circumstances does not depend on any other Layer.

Each `Layer` must have method `#call(*args)`, which must return an 
array,  `args` structure in one domain scope does not have to be identical, but
it is highly recommended.

```
class MyAwesomeLayer < Shrek::Layers
  def call(bilder, *args, **options)  # Argument structure is up to you.  
    # do something before next layer
    args = [bilder, *args, options]
    next_layer.call(*args)            # Run next execution Layer
    # some post execution logic. If you add it, keep in mind, that you have to 
    # return args for the next Layer
  rescue SomeError => e
    # We can handle the error here and re-raise it for futher Layers
    # in this order we can split messy error handling and keep everything clean
    
    next_layer.skip(2).call(*args)    # Skip 2 layers and run
    next_layer.skip!(42).call(*args)  # Laught version. Will Raise if stack is
                                      # not enough
  end
end
```

You can see more
[examples](https://github.com/kvokka/shrek/blob/master/spec/shrek/runner_acceptance_spec.rb)

Then you will be able to use desired collection of Layers with 
`Shrek[MyAwesomeLayer, AnotherOne].call(*initial_arguments)`

may be used in own classes
```
  class Paint
    include Shrek
  end
  
  Paint.new.use_layers FindPaints, SelectWall, PrepareBrushes,
                       self_return: ->(result) { a }
```

We also are able to make some tuning with returning value with `self_return` option.
It use something, which respond_to :call.

Let's summarize procs and cons of this concept:

##### Procs

* Maximum encapsulation
* Easy reordering
* Each peace of logic handles only own part of the error
* Readable high level interface with minimal noise
* Standardize interface for one peace of domain logic
* Static analyzers will be happy
* Simple tests
* Well documented by someone else ;)

##### Cons

* One more abstraction layer
* Can be over-engineering 
* Requires more memory
* More code, more files

### Why do I need it?

Lets try to put this little snippet of a tale into a code . Given:

> Shrek wants to eat something, and he decides to do a slug soup. He got
> slugs and then went to get some wood for the fireplace. When he came back
> he put the wood into the fireplace and tried to make fire. But he did not find
> matches, so he had to move the wood back. He then made shashimi from the
> slugs and ate as much as he could.He put the rest of the food into the fridge.

It is a simple business story, but think for a while, how will you solve it?
And keep in mind, that in the real world a lot of things can go wrong and you
want to be able to extend this story, when author decides, that Shrek also has
to try to find the lighter or add some swamp spices for better flavor (or 
onion)

The simplest way is 

```
  class ServiceKlass
    def initialize(*)
      # ...
    end 
   
    def call
      # ...
    end
  end
```

But you will have to keep explicit error handler, and resolve all sort of 
errors there. You will not be able to share one error between parts of the 
service class, so you will do new error names or generalize errors (again, this
pattern is for big and heavy tasks). So the error handler will grow (May be you also
extract it ). At the end you will find yourself with a mess.
Do not believe me? Ok, take default `Rails::Middleware` and try to rewrite it 
in procedural style this weekend (and do not plan anything else, you will have
lot's of fun ;)

Another way to handle this sort of  problem is `composite` pattern (the first 
example of this pattern, which came to me is `ActiveRecord::Migration`). It will
aim at the same goal, but also you will get DSL of the `composite`. Also you will
not be able to have the ability of error splitting. Usually it is suitable.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem to your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shrek. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Shrek project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/shrek/blob/master/CODE_OF_CONDUCT.md).
