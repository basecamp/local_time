module LocalTimeHelper
  def local_time(time, options = nil)
    time = utc_time(time)

    # Here we extract the format option from the options hash.
    # We will add it back later.
    # format12 is a String or a Symbol.
    options, format12 = extract_options_and_value(options, :format)
    # > extract_options_and_value({ format: "%B %d, %Y" }, :format)
    # => [{}, "%B %d, %Y"]
    # > extract_options_and_value(:db, :format)
    # => [{}, :db]

    # We transform Symbol format12 into a String.
    format12, format24 = find_time_formats(format12)
    # > find_time_formats("%B %d, %Y")
    # => ["%B %d, %Y", nil]
    # > find_time_formats(:db)
    # => ["%Y-%m-%d %H:%M:%S", nil]

    # We first create a data hash if it doesn't exist
    # Then we add back the format option along with the local and format24 options.
    options[:data] ||= {}
    options[:data].merge! local: :time, format: format12, format24: format24

    time_tag time, time.strftime(format12), options
  end

  def local_date(time, options = nil)
    # options, format = extract_options_and_value(options, :format)
    # options[:format] = format || LocalTime.default_date_format
    # local_time time, options
    time = utc_time(time)

    options, date_format = extract_options_and_value(options, :format)
    date_format = find_date_format(date_format)

    options[:data] ||= {}
    options[:data].merge! local: :time, format: date_format

    time_tag time, time.strftime(date_format), options
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

    ## TIME ##

    def find_time_formats(format12)
      if format12.is_a?(Symbol)
        # If format12 is a Symbol (like :db), we try to find the corresponding String format.
        find_time_formats_by_name(format12)
      else
        [ format12.presence || LocalTime.default_time_format, nil ]
      end
    end

    def find_time_formats_by_name(name)
      if use_i18n_time_formats?(name)
        # Examples: :short and :long
        find_i18_time_formats(name)
      elsif use_ruby_time_formats?(name)
        # Examples: :db and :number
        find_ruby_time_formats(name)
      else
        [ LocalTime.default_time_format, nil ]
      end
    end

    def use_i18n_time_formats?(name)
      i18n_time_or_date_format(name).present?
    end

    def i18n_time_or_date_format(name)
      # We look for the format in the time.formats scope.
      # If not found, we look in the date.formats scope.
      I18n.t("time.formats.#{name}", default: [ :"date.formats.#{name}", "" ]).presence
    end

    def find_i18_time_formats(name)
      [ i18n_time_or_date_format(name), i18n_time_or_date_format("#{name}_24h") ]
    end

    def use_ruby_time_formats?(name)
      ruby_preferred_format(name).present?
    end

    def find_ruby_time_formats(name)
      format12 = ruby_preferred_format(name)

      if format12.is_a?(Proc)
        [ LocalTime.default_time_format, nil ]
      else
        [ format12, ruby_preferred_format("#{name}_24h") ]
      end
    end

    ## DATE ##

    def find_date_format(date_format)
      if date_format.is_a?(Symbol)
        find_date_format_by_name(date_format)
      else
        date_format.presence || LocalTime.default_date_format
      end
    end

    def find_date_format_by_name(name)
      if use_i18n_date_format?(name)
        find_i18n_date_format(name)
      elsif use_ruby_date_format?(name)
        find_ruby_date_format(name)
      else
        LocalTime.default_time_format
      end
    end

    def use_i18n_date_format?(name)
      i18n_date_format(name).present?
    end

    def i18n_date_format(name)
      I18n.t("date.formats.#{name}", default: [ :"time.formats.#{name}", "" ]).presence
    end

    def find_i18n_date_format(name)
      i18n_date_format(name)
    end

    def use_ruby_date_format?(name)
      ruby_preferred_format(name, prefer: :date).present?
    end

    def find_ruby_date_format(name)
      ruby_preferred_format(name, prefer: :date)
    end

    ## COMMON ##

    def ruby_preferred_format(name, prefer: :time)
      if prefer == :time
        Time::DATE_FORMATS.with_indifferent_access[name] || Date::DATE_FORMATS.with_indifferent_access[name]
      else
        Date::DATE_FORMATS.with_indifferent_access[name] || Time::DATE_FORMATS.with_indifferent_access[name]
      end
    end
end
