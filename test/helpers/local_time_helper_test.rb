require_relative '../../app/helpers/local_time_helper'
require 'active_support/all'
require 'action_view'
require 'rails-dom-testing'

require 'minitest/autorun'
begin
  # 2.0.0
  class TestCase < MiniTest::Test; end
rescue NameError
  # 1.9.3
  class TestCase < MiniTest::Unit::TestCase; end
end

I18n.enforce_available_locales = false

class LocalTimeHelperTest < TestCase
  include ActionView::Helpers::DateHelper, ActionView::Helpers::TagHelper
  include Rails::Dom::Testing::Assertions::DomAssertions

  include LocalTimeHelper

  def setup
    @original_zone = Time.zone
    Time.zone = ActiveSupport::TimeZone["Central Time (US & Canada)"]
    I18n.backend.store_translations(:en, {
      time: { formats: { simple_time: "%b %e" } },
      date: { formats: { simple_date: "%b %e" } } })
    Time::DATE_FORMATS[:time_formats_simple_time] = '%b %e'
    Date::DATE_FORMATS[:date_formats_simple_date] = '%b %e'

    @date = "2013-11-21"
    @time = Time.zone.parse(@date)
    @time_utc = "2013-11-21 06:00:00 UTC"
    @time_js = "2013-11-21T06:00:00Z"
  end

  def teardown
    Time.zone = @original_zone
  end

  def test_utc_time_with_a_date
    date = Date.parse(@date)
    assert_equal @time_utc, utc_time(date).to_s
  end

  def test_utc_time_with_a_local_time
    assert_equal @time_utc, utc_time(@time).to_s
  end

  def test_utc_time_with_a_utc_time
    assert_equal @time_utc, utc_time(@time.utc).to_s
  end

  def test_local_time
    expected = %Q(<time data-format="%B %e, %Y %l:%M%P" data-local="time" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_dom_equal expected, local_time(@time)
  end

  def test_local_time_with_format
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_dom_equal expected, local_time(@time, format: '%b %e')
  end

  def test_local_time_with_format_as_string
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_dom_equal expected, local_time(@time, '%b %e')
  end

  def test_local_time_with_i18n_format
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_dom_equal expected, local_time(@time, format: :simple_time)
  end

  def test_local_time_with_date_formats_format
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_dom_equal expected, local_time(@time, format: :time_formats_simple_time)
  end

  def test_local_time_with_missing_i18n_and_date_formats_format
    expected = %Q(<time data-format="%B %e, %Y %l:%M%P" data-local="time" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_dom_equal expected, local_time(@time, format: :missing_format)
  end

  def test_local_time_with_date_formats_proc_format
    Time::DATE_FORMATS[:proc] = proc { |time| "nope" }
    expected = %Q(<time data-format="%B %e, %Y %l:%M%P" data-local="time" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_dom_equal expected, local_time(@time, format: :proc)
  end

  def test_local_time_with_options
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}" style="display:none">Nov 21</time>)
    assert_dom_equal expected, local_time(@time, format: '%b %e', style: 'display:none')
  end

  def test_local_date
    expected = %Q(<time data-format="%B %e, %Y" data-local="time" datetime="#{@time_js}">November 21, 2013</time>)
    assert_dom_equal expected, local_date(@time)
    assert_dom_equal expected, local_date(@time.to_date)
  end

  def test_local_date_with_format
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_dom_equal expected, local_date(@time.to_date, format: '%b %e')
  end

  def test_local_date_with_format_as_string
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_dom_equal expected, local_date(@time.to_date, '%b %e')
  end

  def test_local_date_with_i18n_format
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_dom_equal expected, local_date(@time.to_date, format: :simple_date)
  end

  def test_local_date_with_date_formats_format
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_dom_equal expected, local_date(@time.to_date, format: :date_formats_simple_date)
  end

  def test_local_date_with_missing_i18n_and_date_formats_format
    expected = %Q(<time data-format="%B %e, %Y %l:%M%P" data-local="time" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_dom_equal expected, local_date(@time.to_date, format: :missing_date_format)
  end

  def test_local_time_ago
    expected = %Q(<time data-local="time-ago" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_dom_equal expected, local_time_ago(@time)
  end

  def test_local_time_ago_with_options
    expected = %Q(<time class="date-time" data-local="time-ago" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_dom_equal expected, local_time_ago(@time, class: "date-time")
  end

  def test_relative_time
    expected = %Q(<time data-local="time-or-date" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_dom_equal expected, local_relative_time(@time, type: "time-or-date")
  end

  def test_local_time_ago_with_type_as_string
    expected = %Q(<time data-local="time-or-date" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_dom_equal expected, local_relative_time(@time, "time-or-date")
  end
end
