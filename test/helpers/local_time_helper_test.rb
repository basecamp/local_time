require_relative '../../app/helpers/local_time_helper'
require 'active_support/all'
require 'action_view'
require 'minitest/autorun'


class LocalTimeHelperTest < MiniTest::Unit::TestCase
  include ActionView::Helpers::DateHelper, ActionView::Helpers::TagHelper
  include LocalTimeHelper

  def setup
    @original_zone = Time.zone
    Time.zone = ActiveSupport::TimeZone["Central Time (US & Canada)"]

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
    assert_equal expected, local_time(@time)
  end

  def test_local_time_with_format
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_equal expected, local_time(@time, format: '%b %e')
  end

  def test_local_time_with_options
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}" style="display:none">Nov 21</time>)
    assert_equal expected, local_time(@time, format: '%b %e', style: 'display:none')
  end

  def test_local_date
    expected = %Q(<time data-format="%B %e, %Y" data-local="time" datetime="#{@time_js}">November 21, 2013</time>)
    assert_equal expected, local_date(@time)
    assert_equal expected, local_date(@time.to_date)
  end

  def test_local_date_with_format
    expected = %Q(<time data-format="%b %e" data-local="time" datetime="#{@time_js}">Nov 21</time>)
    assert_equal expected, local_date(@time, format: '%b %e')
  end

  def test_local_time_ago
    expected = %Q(<time data-local="time-ago" datetime="#{@time_js}">November 21, 2013  6:00am</time>)
    assert_equal expected, local_time_ago(@time)
  end
end
