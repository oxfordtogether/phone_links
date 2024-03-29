module ApplicationHelper
  include Pagy::Frontend

  def format_date_as_relative(date)
    return unless date

    if date.today?
      "today"
    elsif (Date.today.to_date - date.to_date).to_i == 1
      "1 day"
    else
      "#{(Date.today.to_date - date.to_date).to_i} days"
    end
  end

  def format_date_as_days_since(date)
    return unless date

    if date.today?
      "today"
    elsif (Date.today.to_date - date.to_date).to_i == 1
      "yesterday"
    else
      "#{(Date.today.to_date - date.to_date).to_i} days ago"
    end
  end

  def format_date(date)
    return unless date

    if date.today?
      if date.instance_of? Date
        date.strftime("#{date.day.ordinalize} %b")
      else
        date.strftime("%H:%M")
      end
    elsif date.year == Date.today.year
      date.strftime("#{date.day.ordinalize} %b")
    else
      date.strftime("#{date.day.ordinalize} %b %Y")
    end
  end

  def format_datetime(datetime)
    return unless datetime

    datetime.strftime("#{datetime.day.ordinalize} %b %Y at %I:%M%p")
  end

  def caller_duration(datetime)
    return unless datetime

    date_today = DateTime.now
    date_start = datetime.to_datetime
    number_days = (date_today - date_start).to_i
    number_years = number_days / 365
    number_days_left = number_days % 365

    if number_years == 0 && number_days <= 1
      "#{number_days_left} day"
    elsif number_years == 0
      "#{number_days_left} days"
    else
      "#{number_years} year #{number_days_left} days"
    end
  end

  def last_report_days(datetime)
    return unless datetime

    date_today = DateTime.now
    date_start = datetime.to_datetime
    number_days = (date_today - date_start).to_i
    if number_days <= 1
      "#{number_days} day"
    else
      "#{number_days} days"
    end
  end

  def address_to_string(person)
    address = ""
    address += "#{person.address_line_1}, " if person.address_line_1.present?
    address += "#{person.address_line_2}, " if person.address_line_2.present?
    address += "#{person.address_town}, " if person.address_town.present?
    address += "#{person.address_postcode}, " if person.address_postcode.present?

    address.gsub(/, $/, "")
  end

  def current_page_starts_with?(url_string)
    request_uri = URI.parser.unescape(request.fullpath).force_encoding(Encoding::BINARY)

    request_uri.starts_with?(url_string)
  end
end
