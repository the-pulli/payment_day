# frozen_string_literal: true

require "date"
require "terminal-table"
require "rainbow"
require_relative "payment_day/version"

module PaymentDay
  # View class
  class View
    attr_reader :pay_days, :years

    def initialize(*years)
      default_options = { separator: true, ascii: false, dayname: false, page: nil, pages: nil, duplicates: false, footer: true }
      options = years.last.is_a?(Hash) ? years.slice!(-1) : {}
      @months = []
      @options = default_options.merge options.transform_keys(&:to_sym)
      @years = prepare_years(years)
      @pay_days = find_pay_days
    end

    def list
      Terminal::Table.new do |t|
        t.title = Rainbow("Pay days").bright
        t.headings = [Rainbow("Month").bright] + @years.map { |y| { value: Rainbow(y).bright, alignment: :center } }
        t.style = { all_separators: @options[:separator], border: border }
        t.rows = @months.map { |m| Rainbow(m).cyan }.zip(*format_pay_days)
        @years.each_index { |v| t.align_column v.next, :center }
        page = @options[:page]
        pages = @options[:pages]
        unless !@options[:footer] || (page.nil? || (page == 1 && pages == 1))
          t.add_row [{ colspan: @years.length.next, value: "Page #{page}/#{pages}",
                       alignment: :center }]
        end
      end
    end

    alias show list

    private

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
      unless @options[:duplicates]
        year_hsh = {}
        @years.each.with_index do |year, index|
          year_hsh[year] = (1..12).to_a.map do |month|
            last_day = Date.parse("#{year}-#{month}-01").next_month.prev_day
            @months.push(last_day.strftime("%B")) if index.zero?
            prev(last_day)
          end
        end
        return year_hsh
      end

      @years.map.with_index do |year, index|
        (1..12).to_a.map do |month|
          last_day = Date.parse("#{year}-#{month}-01").next_month.prev_day
          @months.push(last_day.strftime("%B")) if index.zero?
          prev(last_day)
        end
      end
    end

    def format_pay_days
      format = @options[:dayname] ? "%a, %d" : "%d"
      return @pay_days.map { |_, year| year.map { |d| Rainbow(d.strftime(format)).green } } unless @options[:duplicates]

      @pay_days.map { |year| year.map { |d| Rainbow(d.strftime(format)).green } }
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
