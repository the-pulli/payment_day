# frozen_string_literal: true

require "date"
require "terminal-table"
require "rainbow"
require_relative "payment_day/version"

module PaymentDay
  # View class
  class View
    MONTHS = %w[January February March April May June July August September October November December].freeze

    attr_reader :pay_days

    def initialize(*years)
      options = years.last.is_a?(Hash) ? years.slice!(-1) : {}
      @years = Array(prepare_years(years))
      @pay_days = find_pay_days
      @options = { separator: true, ascii: false }.merge options.transform_keys(&:to_sym)
    end

    def list
      Terminal::Table.new do |t|
        t.title = Rainbow("Pay days").bright
        t.headings = [Rainbow("Month").bright] + @years.map { |y| Rainbow(y).bright }
        t.style = { all_separators: @options[:separator], border: border }
        t.rows = MONTHS.map { |m| Rainbow(m).cyan }.zip(*format_pay_days)
        @years.each_index { |v| t.align_column v.next, :center }
      end
    end

    alias show list

    private

    def prepare_years(years)
      years.flatten.map do |year|
        case year
        when Range
          year.to_a
        when String
          range = year.split("-")
          if range.first.to_i <= range.last.to_i
            Range.new(range.first, range.last).to_a
          else
            Range.new(range.last, range.first).to_a
          end
        else
          year
        end
      end.flatten
    end

    def find_pay_days
      @years.map do |year|
        (1..12).to_a.map do |month|
          last_day = Date.parse("#{year}-#{month}-01").next_month.prev_day
          prev(last_day)
        end
      end
    end

    def format_pay_days
      @pay_days.map { |year| year.map { |d| Rainbow(d.strftime("%d")).green } }
    end

    def prev(day)
      return day if (1..5).include? day.wday

      prev(day.prev_day)
    end

    def border
      @options[:ascii] ? :ascii : :unicode_round
    end
  end
end
