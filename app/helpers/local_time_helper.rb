module LocalTimeHelper
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

    time_tag time, time.strftime('%B %e, %Y %l:%M%P'), options
  end

  def utc_time(time_or_date)
    if time_or_date.respond_to?(:in_time_zone)
      time_or_date.in_time_zone.utc
    else
      time_or_date.to_time.utc
    end
  end

  private
    def time_format(format, default = '%B %e, %Y %l:%M%P')
      case
      when format.blank?
        default
      when i18n_format = I18n.t("time.formats.#{format}", default: [:"date.formats.#{format}", '']).presence
        i18n_format
      when date_format = Time::DATE_FORMATS[format] || Date::DATE_FORMATS[format]
        if date_format.is_a?(Proc)
          default
        else
          date_format
        end
      when format.present?
        format
      else
        default
      end
    end
end
