module LocalTimeHelper
  def local_time(time, format = '%B %e, %Y %l:%M%P')
    time = utc_time(time)
    time_tag time, time.strftime(format), data: { local: :time, format: format }
  end

  def local_date(date, format = '%B %e, %Y')
    date = utc_time(date).to_date
    time_tag date, date.strftime(format), data: { local: :date, format: format }
  end

  def local_time_ago(time)
    time = utc_time(time)
    time_tag time, time.strftime('%B %e, %Y %l:%M%P'), data: { local: 'time-ago' }
  end

  def utc_time(time_or_date)
    if time_or_date.respond_to?(:in_time_zone)
      time_or_date.in_time_zone.utc
    else
      time_or_date.to_time.utc
    end
  end
end
