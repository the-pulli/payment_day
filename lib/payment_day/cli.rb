# frozen_string_literal: true

require "payment_day"
require "thor"

module PaymentDay
  # CLI class for PayDay
  class CLI < Thor
    desc "list", "Lists all pay days for the given year(s)"
    method_option :ascii, aliases: "-a", type: :boolean, default: false
    method_option :columns, aliases: "-c", type: :numeric, default: 10
    method_option :dayname, aliases: "-n", type: :boolean, default: true
    method_option :duplicates, aliases: "-d", type: :boolean, default: false
    method_option :footer, aliases: "-f", type: :boolean, default: true
    method_option :separator, aliases: "-s", type: :boolean, default: true
    def list(*years)
      years = PaymentDay::View.new(years, options).years
      years = years.each_slice(options[:columns])
      years.each_with_index do |yearsChunk, page|
        year_options = options.dup
        year_options[:page] = page.next
        year_options[:pages] = years.to_a.length
        puts PaymentDay::View.new(yearsChunk, year_options).list()
      end
    end
  end
end
