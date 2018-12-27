# crude-mutant (https://travis-ci.org/kellysutton/crude-mutant.svg?branch=master)](https://travis-ci.org/kellysutton/crude-mutant)

A Ruby-based, language-agnostic tool for performing [mutation testing](https://en.wikipedia.org/wiki/Mutation_testing) on a file.

This tool is relatively crude (hence the name) in that it will just remove lines one by one to detect which is a dangerous mutation (i.e. a line removed where all tests still pass).

## Installation

In your preferred shell…

```
gem install crude-mutant
```

## Usage

The script is started by providing the file you wish to modify and then the command used to test the code.

It's assumed that the command will return a non-zero status code on test failure.

Here's a Ruby-centric example:

```
crude-mutant "app/models/post.rb" "bundle exec rspec"
```

You can also use the shortened `cm`:

```
cm "app/models/post.rb" "bundle exec rspec"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kellysutton/crude-mutant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Crude::Mutant project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kellysutton/crude-mutant/blob/master/CODE_OF_CONDUCT.md).
