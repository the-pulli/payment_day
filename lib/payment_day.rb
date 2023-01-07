# frozen_string_literal: true

require "date"
require "terminal-table"
require "rainbow"
require_relative "payment_day/version"

module PaymentDay
  # View class
  class View
    DEFAULT_OPTIONS = {
      ascii: false,
      colors: true,
      columns: 10,
      dayname: false,
      duplicates: false,
      footer: true,
      page: nil,
      pages: nil,
      separator: true
    }.freeze

    private_class_method :new

    attr_reader :pay_days, :years

    def initialize(*years)
      options = years.last.is_a?(Hash) ? years.slice!(-1) : {}
      @months = []
      @options = DEFAULT_OPTIONS.merge options.transform_keys(&:to_sym)
      @years = prepare_years(years)
      @pay_days = find_pay_days
    end

    def self.create(*years)
      new(*years)
    end

    def list
      Terminal::Table.new do |t|
        t.title = format("Pay days", :bright)
        t.headings = [format("Month", :bright)] + @years.map do |y|
          { value: format(y, :bright), alignment: :center }
        end
        t.style = { all_separators: @options[:separator], border: border }
        t.rows = @months.map { |m| format(m, :cyan) }.zip(*format_pay_days)
        @years.each_index { |v| t.align_column v.next, :center }
        page = @options[:page]
        pages = @options[:pages]
        if @options[:footer] && pages > 1
          t.add_row [{ colspan: @years.length.next, value: "Page #{page}/#{pages}",
                       alignment: :center }]
        end
      end
    end

    alias show list

    private

    def format(value, color)
      @options[:colors] ? Rainbow(value).send(color) : value
    end

    def prepare_years(years)
      result = years.flatten.map do |year|
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

      result = result.uniq unless @options[:duplicates]
      Array(result)
    end

    def find_pay_days
      year_hsh = {}
      years_ary = @years.map.with_index do |year, index|
        year_hsh[year] = (1..12).to_a.map do |month|
          last_day = Date.parse("#{year}-#{month}-01").next_month.prev_day
          @months.push(last_day.strftime("%B")) if index.zero?
          prev(last_day)
        end
      end
      return years_ary if @options[:duplicates]

      year_hsh
    end

    def format_pay_days
      format = @options[:dayname] ? "%a, %d" : "%d"
      formatter = lambda { |days|
        days.map do |d|
          day = d.strftime(format)
          format(day, :green)
        end
      }

      if @options[:duplicates]
        @pay_days.map { |days| formatter.call(days) }
      else
        @pay_days.map { |_, days| formatter.call(days) }
      end
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
