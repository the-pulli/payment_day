# PaymentDay

Provides a class PaymentDay::View. This class generates the pay days for the given year(s).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pay_day

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pay_day

## Usage

```ruby
# Get the pay days
PaymentDay::View(2023).pay_days # return Array of Hash(es) with the pay_days
PaymentDay::View("2023").pay_days # accept String as input
PaymentDay::View(2023, 2024).pay_days # accept multiple years
PaymentDay::View([2023]).pay_days # accept Array's as input
PaymentDay::View("2023-2024").pay_days # accept String ranges
PaymentDay::View(2023..2024).pay_days # accept Range as input
PaymentDay::View(2023..2024, 2025, '2026').pay_days # accept a mix of all of them

# Last parameter defines the options if set
# shows 2023 twice in the list of pay_days, default is false
PaymentDay::View(2023..2024, 2023, duplicates: true).pay_days

table = PaymentDay::View(2023).list # returns a Terminal::Table instance
puts table # which can be printed like this
```

### payment_day executable supports the following options:

Option | Negated | Shortcut | Default
--- | ---: | ---: | ---:
--ascii | --no-ascii | -a | false
--columns | | -c | 10
--dayname | --no-dayname | -e | true
--duplicates | --no-duplicates | -d | false
--footer | --no-footer | -f | true
--header | --no-header | -h | true
--separator | --no-separator | -s | true

```bash
payment_day view 2023 2024 2025-2027
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/the-pulli/payment_day.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
