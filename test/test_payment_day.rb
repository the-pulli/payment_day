# frozen_string_literal: true

require "test_helper"

class TestPayDay < Minitest::Test
  include PaymentDay

  def setup
    @pd_one_year = [{ 2023 => [31, 28, 31, 28, 31, 30, 31, 31, 29, 31, 30, 29] }]
    @pd_one_year_dup = [[31, 28, 31, 28, 31, 30, 31, 31, 29, 31, 30, 29],
                        [31, 28, 31, 28, 31, 30, 31, 31, 29, 31, 30, 29]]
    @pd_two_years = [{ 2024 => [31, 29, 29, 30, 31, 28, 31, 30, 30, 31, 29, 31],
                       2025 => [31, 28, 31, 30, 30, 30, 31, 29, 30, 31, 28, 31] }]
    @pd_two_years_dup = [[31, 29, 29, 30, 31, 28, 31, 30, 30, 31, 29, 31],
                         [31, 28, 31, 30, 30, 30, 31, 29, 30, 31, 28, 31],
                         [31, 29, 29, 30, 31, 28, 31, 30, 30, 31, 29, 31],
                         [31, 28, 31, 30, 30, 30, 31, 29, 30, 31, 28, 31]]
    @pd_multiple_years = [(@pd_one_year + @pd_two_years).map(&:to_a).flatten(1).to_h]
  end

  def test_that_it_has_a_version_number
    refute_nil ::PaymentDay::VERSION
  end

  def test_pay_days_for_one_year
    [
      View.new(2023),
      View.new("2023"),
      View.new("2023-2023"),
      View.new(2023..2023)
    ].each { |days| assert_equal @pd_one_year, convert_pay_days(days) }
  end

  def test_pay_days_for_two_years
    [
      View.new([2024, 2025]),
      View.new(2024, 2025),
      View.new("2024-2025"),
      View.new("2025-2024"),
      View.new(2024..2025),
      View.new(2024, 2025, 2025)
    ].each { |days| assert_equal @pd_two_years, convert_pay_days(days) }
  end

  def test_pay_days_for_multiple_years
    [
      View.new([2023, 2024, 2025]),
      View.new(2023, 2024, 2025),
      View.new("2023-2025"),
      View.new("2025-2023"),
      View.new(2023..2025),
      View.new(2023, 2024, 2025, 2025)
    ].each { |days| assert_equal @pd_multiple_years, convert_pay_days(days) }
  end

  def test_pay_days_for_years_with_duplicates
    [
      [View.new(2023, 2023, duplicates: true), @pd_one_year_dup],
      [View.new(2024, 2025, 2024, 2025, duplicates: true), @pd_two_years_dup],
    ].each { |ary| assert_equal ary.last, convert_dup_pay_days(ary.first) }
  end

  private

  def convert_pay_days(view)
    pay_days = {}
    view.pay_days.each do |year, v|
      pay_days[year.to_i] = v.map { |d| d.day }
    end
    [pay_days]
  end

  def convert_dup_pay_days(view)
    view.pay_days.map { |year| year.map(&:day) }
  end
end
