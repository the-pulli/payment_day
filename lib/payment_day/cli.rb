# frozen_string_literal: true

require "payment_day"
require "thor"

module PaymentDay
  # CLI class for PayDay
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "view YEARS", "Lists all pay days for the given year(s)"
    method_option :ascii, aliases: "-a", type: :boolean, default: false, desc: "Do you want to have a ASCII table printed?"
    method_option :columns, aliases: "-c", type: :numeric, default: 10, desc: "How many years (columns) do you wanna display in one table?"
    method_option :colors, type: :boolean, default: true, desc: "Do you want colored output?"
    method_option :dayname, aliases: "-e", type: :boolean, default: true, desc: "Do you want see the day name?"
    method_option :duplicates, aliases: "-d", type: :boolean, default: false, desc: "Do you want see duplicates?"
    method_option :footer, aliases: "-f", type: :boolean, default: true, desc: "Do you want see the table footer?"
    method_option :header, aliases: "-h", type: :boolean, default: true, desc: "Do you wanna see the table title?"
    method_option :separator, aliases: "-s", type: :boolean, default: true, desc: "Do you want to have a separator for the rows printed?"
    def view(*years)
      PaymentDay::Views.new(years, options).print
    end
  end
end
