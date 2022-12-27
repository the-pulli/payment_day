# frozen_string_literal: true

require "test_helper"

class TestPayDay < Minitest::Test
  include PaymentDay

  def setup
    @pd2023 = [[Date.parse("2023-01-31 ((2459976j,0s,0n),+0s,2299161j"),
                Date.parse("2023-02-28 ((2460004j,0s,0n),+0s,2299161j"),
                Date.parse("2023-03-31 ((2460035j,0s,0n),+0s,2299161j"),
                Date.parse("2023-04-28 ((2460063j,0s,0n),+0s,2299161j"),
                Date.parse("2023-05-31 ((2460096j,0s,0n),+0s,2299161j"),
                Date.parse("2023-06-30 ((2460126j,0s,0n),+0s,2299161j"),
                Date.parse("2023-07-31 ((2460157j,0s,0n),+0s,2299161j"),
                Date.parse("2023-08-31 ((2460188j,0s,0n),+0s,2299161j"),
                Date.parse("2023-09-29 ((2460217j,0s,0n),+0s,2299161j"),
                Date.parse("2023-10-31 ((2460249j,0s,0n),+0s,2299161j"),
                Date.parse("2023-11-30 ((2460279j,0s,0n),+0s,2299161j"),
                Date.parse("2023-12-29 ((2460308j,0s,0n),+0s,2299161j")]]
    @pd_multiple_years = [
      [
        Date.parse("2024-01-31 ((2460341j,0s,0n),+0s,2299161j"),
        Date.parse("2024-02-29 ((2460370j,0s,0n),+0s,2299161j"),
        Date.parse("2024-03-29 ((2460399j,0s,0n),+0s,2299161j"),
        Date.parse("2024-04-30 ((2460431j,0s,0n),+0s,2299161j"),
        Date.parse("2024-05-31 ((2460462j,0s,0n),+0s,2299161j"),
        Date.parse("2024-06-28 ((2460490j,0s,0n),+0s,2299161j"),
        Date.parse("2024-07-31 ((2460523j,0s,0n),+0s,2299161j"),
        Date.parse("2024-08-30 ((2460553j,0s,0n),+0s,2299161j"),
        Date.parse("2024-09-30 ((2460584j,0s,0n),+0s,2299161j"),
        Date.parse("2024-10-31 ((2460615j,0s,0n),+0s,2299161j"),
        Date.parse("2024-11-29 ((2460644j,0s,0n),+0s,2299161j"),
        Date.parse("2024-12-31 ((2460676j,0s,0n),+0s,2299161j")
      ],
      [
        Date.parse("2025-01-31 ((2460707j,0s,0n),+0s,2299161j"),
        Date.parse("2025-02-28 ((2460735j,0s,0n),+0s,2299161j"),
        Date.parse("2025-03-31 ((2460766j,0s,0n),+0s,2299161j"),
        Date.parse("2025-04-30 ((2460796j,0s,0n),+0s,2299161j"),
        Date.parse("2025-05-30 ((2460826j,0s,0n),+0s,2299161j"),
        Date.parse("2025-06-30 ((2460857j,0s,0n),+0s,2299161j"),
        Date.parse("2025-07-31 ((2460888j,0s,0n),+0s,2299161j"),
        Date.parse("2025-08-29 ((2460917j,0s,0n),+0s,2299161j"),
        Date.parse("2025-09-30 ((2460949j,0s,0n),+0s,2299161j"),
        Date.parse("2025-10-31 ((2460980j,0s,0n),+0s,2299161j"),
        Date.parse("2025-11-28 ((2461008j,0s,0n),+0s,2299161j"),
        Date.parse("2025-12-31 ((2461041j,0s,0n),+0s,2299161j")
      ]
    ]
  end

  def test_that_it_has_a_version_number
    refute_nil ::PaymentDay::VERSION
  end

  def test_pay_days_for_one_year
    assert_equal @pd2023, View.new(2023).pay_days
    assert_equal @pd2023, View.new([2023]).pay_days
  end

  def test_pay_days_for_multiple_years
    assert_equal @pd_multiple_years, View.new([2024, 2025]).pay_days
    assert_equal @pd_multiple_years, View.new(2024, 2025).pay_days
    assert_equal @pd_multiple_years, View.new("2024-2025").pay_days
    assert_equal @pd_multiple_years, View.new("2025-2024").pay_days
    assert_equal @pd_multiple_years, View.new(2024..2025).pay_days
  end
end
