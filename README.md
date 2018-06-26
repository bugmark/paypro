# Paypro

Bugmark Payment Processor

This gem interfaces with payment processors, normalizing
payment operations into a standard Bugmark-compatible
workflow.

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
   yaml: {} 
}
```

Here are the options for specifying service credentials
(in priority order):

1) as an optional parameter during object creation 

    `Paypro.new(<svc_type>, <processor_name>, <currency>, [{credentials hash}])`
  
2) as a yaml file in the current directory `./.paypro_rc.yml`
3) as a yaml file in your home directory `~/.paypro_rc.yml`

### Paypro Demo

The Paypro class has three instance methods:

- `collect`
  collects funds from the user and deposits them into the pool
- `distribute`
  withdraws funds from the pool and distributes to the user
- `pool_balance`
  shows the pool balance
  
Sample Code:
  
    require 'bugmark/exchange'
    require 'bugmark/paypro'  
    paypro = Paypro.new(<svc_type>, <paypro_name>, <currency>)
    user   = UserCmd::Create(email, name)
    ledger = UserCmd::CreateLedger(user, paypro.to_hash)
    paypro.pool_balance                        #=> 100
    if paypro.collect(1000, user.to_hash, CC_number)
      UserCmd::LedgerDeposit(1000, ledger)
    end
    paypro.pool_balance                        #=> 1100
    if paypro.distribute(200, user.to_hash, CC_number)
      UserCmd::LedgerWithdraw(200, ledger)
    end
    paypro.pool_balance                        #=> 900

Note that each Paypro service implements unique collection
and distribution methods.  Some may collect via credit-card,
some by invoice, some by EFT.  Some Paypros may distribute
funds via handwritten check, or banking payment services, 
or blockchain payment.

Each Paypro is resonsible for implementing it's own pool.
Some may choose to use a commercial bank account, others may
store the pool on the blockchain, others may use a CSV file.

Each Paypro is responsible for collecting and safely 
storing user credentials, credit card numbers, etc.

Each Paypro is responsible for maintaining compliance with
regulatory and tax rules.

### Future Direction

This Paypro implementation is MVP.

As you can see, it is the responsibility of the application
to keep the pool and user ledgers in sync.

Probably in the future we'll explore design alternatives:
- signed/registered paypros
- a library that collects and deposits in one transaction

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
