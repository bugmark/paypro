# Paypro

Bugmark Payment Processor

This gem interfaces with payment processors, normalizing payment operations
into a standard Bugmark-compatible format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paypro', github: 'bugmark/paypro '
```

And then execute:

    $ bundle
    
## Details

Valid source types are `:striim` and `:yaml`.

processor credentials are stored in a hash:
   
```ruby
{
   striim: {username: "name", password: "pass"}, 
   yaml: {} # no credentials needed for YAML 
}
```

Here are the options for specifying processor credentials (in priority order):

1) as an optional parameter during object creation 

    `Paypro.new(<processor_type>, <processor_name>, [{credentials hash}])`
  
2) as a yaml file in the current directory `./.paypro_rc.yml`
3) as a yaml file in your home directory `~/.paypro_rc.yml`

### Paypro Demo

    paypro = Paypro.new(<paypro_uuid>)
    ledger = paypro.ledgers[0]
    ledger.deposit(amount)
    ledger.balance
    ledger.events
    ledger.withdraw(amount)

## Development

After checking out the repo, run `bundle install`
to install dependencies. Then, run `rake spec` to
run the tests. You can also run `bin/iconsole` for
an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run
`bundle exec rake install`. To release a new
version, update the version number in `paypro.rb`,
and then run `bundle exec rake release`, which
will create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on
GitHub at https://github.com/bugmark/paypro.
