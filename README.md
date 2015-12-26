[![Build
Status](https://travis-ci.org/icleversoft/marc_json.png)](https://travis-ci.org/icleversoft/marc_json)
# MARCJson
Simple gem that converts a MARC record to json 


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'marc_json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marc_json

## Usage
**From MARC to JSON**
```
marc_record = MARC::Reader.new(MARC_FILE).first
m_json = MARCjson::Renderer.new( marc_record )
m_json.to_json #=>{...}
```

**From JSON to MARC**
```
m = MARCJson::Reader.new( json )
m.to_marc #=>ISO2709 record
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/icleversoft/marc_json.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

