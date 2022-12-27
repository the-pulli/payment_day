# frozen_string_literal: true

require "payment_day"
require "thor"

module PaymentDay
  # CLI class for PayDay
  class CLI < Thor
    desc "list", "Lists all pay days for the given year(s)"
    method_option :ascii, aliases: "-a", type: :boolean, default: false
    method_option :separator, aliases: "-s", type: :boolean, default: true
    def list(*years)
      puts PaymentDay::View.new(years, options).list
    end
  end
end
