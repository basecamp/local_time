module LocalTimeHelper
  def local_time(time, options = nil)
    time = utc_time(time)

    options, format = extract_options_and_value(options, :format)

    options[:data] ||= {}
    options[:data][:local] = :time
    options[:data].merge! find_format_data(format, :time)

    time_tag time, time.strftime(options[:data][:format]), options
  end

  def local_date(time, options = nil)
    time = utc_time(time)

    options, format = extract_options_and_value(options, :format)

    options[:data] ||= {}
    options[:data][:local] = :time
    options[:data].merge! find_format_data(format, :date)

    time_tag time, time.strftime(options[:data][:format]), options
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
    options[:type] = "time-ago"
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

    # This method makes more sense, but it makes a legacy test fail.
    # def find_format_data(format, type)
    #   data = if format.is_a?(Symbol)
    #     use_i18n_format?(format) ? find_i18n_formats(format, type) : find_ruby_formats(format, type)
    #   else
    #     { format: format }
    #   end
    #   data[:format] ||= get_default(type)
    #   data
    # end

    def find_format_data(format, type)
      if format.is_a?(Symbol)
        data = use_i18n_format?(format) ? find_i18n_formats(format, type) : find_ruby_formats(format, type)
        data[:format] ||= LocalTime.default_time_format
        data
      elsif format
        { format: format }
      else
        { format: get_default(type)}
      end
    end

    def use_i18n_format?(name)
      i18n_time_or_date_format(name).present?
    end

    def i18n_time_or_date_format(name)
      I18n.t("time.formats.#{name}", default: [ :"date.formats.#{name}", "" ]).presence
    end

    def find_i18n_formats(name, type)
      if type == :time
        { format: i18n_time_or_date_format(name), format24: i18n_time_or_date_format("#{name}_24h") }
      else
        { format: i18n_time_or_date_format(name) }
      end
    end

    def find_ruby_formats(name, type)
      format_data = ruby_format(name, type)
      if format_data.is_a?(Proc)
        { format: get_default(type) }
      elsif type == :time
        { format: format_data, format24: ruby_format("#{name}_24h") }
      else
        { format: format_data }
      end
    end

    def ruby_format(name, type = :time)
      if type == :time
        Time::DATE_FORMATS.with_indifferent_access[name] || Date::DATE_FORMATS.with_indifferent_access[name]
      else
        Date::DATE_FORMATS.with_indifferent_access[name] || Time::DATE_FORMATS.with_indifferent_access[name]
      end
    end

    def get_default(type)
      type == :time ? LocalTime.default_time_format : LocalTime.default_date_format
    end
end
