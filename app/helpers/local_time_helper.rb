module LocalTimeHelper
  DEFAULT_FORMAT = '%B %e, %Y %l:%M%P'

  def local_time(time, options = {})
    time   = utc_time(time)
    format = time_format(options.delete(:format))

    options[:data] ||= {}
    options[:data].merge! local: :time, format: format

    time_tag time, time.strftime(format), options
  end

  def local_date(time, options = {})
    options.reverse_merge! format: '%B %e, %Y'
    local_time time, options
  end

  def local_time_ago(time, options = {})
    time = utc_time(time)

    options[:data] ||= {}
    options[:data].merge! local: 'time-ago'

    time_tag time, time.strftime(DEFAULT_FORMAT), options
  end

  def utc_time(time_or_date)
    if time_or_date.respond_to?(:in_time_zone)
      time_or_date.in_time_zone.utc
    else
      time_or_date.to_time.utc
    end
  end

  private
    def time_format(format)
      if format.is_a?(Symbol)
        if (i18n_format = I18n.t("time.formats.#{format}", default: [:"date.formats.#{format}", ''])).present?
          i18n_format
        elsif (date_format = Time::DATE_FORMATS[format] || Date::DATE_FORMATS[format])
          date_format.is_a?(Proc) ? DEFAULT_FORMAT : date_format
        else
          DEFAULT_FORMAT
        end
      else
        format.presence || DEFAULT_FORMAT
      end
    end
end
