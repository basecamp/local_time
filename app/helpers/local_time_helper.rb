module LocalTimeHelper
  def local_time(time, options = nil)
    time = utc_time(time)

    options, format = extract_options_and_value(options, :format)
    format = find_time_format(format)

    options[:data] ||= {}
    options[:data].merge! local: :time, format: format

    time_tag time, time.strftime(format), options
  end

  def local_date(time, options = nil)
    options, format = extract_options_and_value(options, :format)
    options[:format] = format || LocalTime.default_date_format
    local_time time, options
  end

  def local_relative_time(time, options = nil)
    time = utc_time(time)
    options, type = extract_options_and_value(options, :type)
    options, format = extract_options_and_value(options, :format)

    options[:data] ||= {}
    options[:data].merge! local: type

    time_tag time, time.strftime(format || LocalTime.default_time_format), options
  end

  def local_time_ago(time, options = nil)
    options, * = extract_options_and_value(options, :type)
    options[:type] = 'time-ago'
    local_relative_time time, options
  end

  def utc_time(time_or_date)
    if time_or_date.respond_to?(:in_time_zone)
      time_or_date.in_time_zone.utc
    else
      time_or_date.to_time.utc
    end
  end

  private
    def find_time_format(format)
      if format.is_a?(Symbol)
        if (i18n_format = I18n.t("time.formats.#{format}", default: [:"date.formats.#{format}", ''])).present?
          i18n_format
        elsif (date_format = Time::DATE_FORMATS[format] || Date::DATE_FORMATS[format])
          date_format.is_a?(Proc) ? LocalTime.default_time_format : date_format
        else
          LocalTime.default_time_format
        end
      else
        format.presence || LocalTime.default_time_format
      end
    end

    def extract_options_and_value(options, value_key = nil)
      case options
      when Hash
        value = options.delete(value_key)
        [ options, value ]
      when NilClass
        [ {} ]
      else
        [ {}, options ]
      end
    end
end
