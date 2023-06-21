module LocalTimeHelper
  def local_time(time, options = nil)
    time = utc_time(time)

    options, format12 = extract_options_and_value(options, :format)
    format12, format24 = find_time_formats(format12)

    options[:data] ||= {}
    options[:data].merge! local: :time, format: format12, format24: format24

    time_tag time, time.strftime(format12), options
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

    def find_time_formats(format12)
      if format12.is_a?(Symbol)
        find_time_formats_by_name(format12)
      else
        [ format12.presence || LocalTime.default_time_format, nil ]
      end
    end

    def find_time_formats_by_name(name)
      if use_i18n_time_formats?(name)
        find_i18_time_formats(name)
      elsif use_ruby_time_formats?(name)
        find_ruby_time_formats(name)
      else
        [ LocalTime.default_time_format, nil ]
      end
    end

    def use_i18n_time_formats?(name)
      i18n_time_or_date_format(name).present?
    end

    def i18n_time_or_date_format(name)
      I18n.t("time.formats.#{name}", default: [:"date.formats.#{name}", ""]).presence
    end

    def find_i18_time_formats(name)
      [ i18n_time_or_date_format(name), i18n_time_or_date_format("#{name}_24h") ]
    end

    def use_ruby_time_formats?(name)
      ruby_time_or_date_format(name).present?
    end

    def ruby_time_or_date_format(name)
      Time::DATE_FORMATS.with_indifferent_access[name] || Date::DATE_FORMATS.with_indifferent_access[name]
    end

    def find_ruby_time_formats(name)
      format12 = ruby_time_or_date_format(name)

      if format12.is_a?(Proc)
        [ LocalTime.default_time_format, nil ]
      else
        [ format12, ruby_time_or_date_format("#{name}_24h") ]
      end
    end
end
