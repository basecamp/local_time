module LocalTimeHelper
  def local_time(time, options = nil)
    time = utc_time(time)

    options, format = extract_options_and_value(options, :format)
    format, format24 = find_time_formats(format)

    options[:data] ||= {}
    options[:data].merge! local: :time, format: format, format24: format24

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

    options[:data] ||= {}
    options[:data].merge! local: type

    time_tag time, time.strftime(LocalTime.default_time_format), options
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

    def find_time_formats(format)
      if format.is_a?(Symbol)
        find_time_formats_by_name(format)
      else
        [ format.presence || LocalTime.default_time_format, nil ]
      end
    end

    def find_time_formats_by_name(format)
      if use_i18n_time_formats?(format)
        find_i18_time_formats(format)
      elsif use_ruby_time_formats?(format)
        find_ruby_time_formats(format)
      else
        [ LocalTime.default_time_format, nil ]
      end
    end

    def use_i18n_time_formats?(format)
      i18n_time_or_date_format(format).present?
    end

    def i18n_time_or_date_format(format)
      I18n.t("time.formats.#{format}", default: [:"date.formats.#{format}", ""]).presence
    end

    def find_i18_time_formats(format)
      [ i18n_time_or_date_format(format), i18n_time_or_date_format("#{format}_24h") ]
    end

    def use_ruby_time_formats?(format)
      ruby_time_or_date_format(format).present?
    end

    def ruby_time_or_date_format(format)
      Time::DATE_FORMATS.with_indifferent_access[format] || Date::DATE_FORMATS.with_indifferent_access[format]
    end

    def find_ruby_time_formats(format)
      format12 = ruby_time_or_date_format(format)
      format12 = format12.is_a?(Proc) ? LocalTime.default_time_format : format12

      [ format12, ruby_time_or_date_format("#{format}_24h") ]
    end
end
