module ApplicationHelper
  include Pagy::Frontend

  def format_date_range(thing)
    if thing.active?
      if thing.end_date
        "#{thing.start_date.strftime('%b %Y')} - #{thing.end_date.strftime('%b %Y')}"
      else
        "#{thing.start_date.strftime('%b %Y')} - ongoing"
      end
    elsif thing.end_date
      "#{thing.start_date.strftime('%b %Y')} - #{thing.end_date.strftime('%b %Y')}"
    else
      "#{thing.start_date.strftime('%b %Y')} - unknown"
    end
  end

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
      "1 day ago"
    else
      "#{(Date.today.to_date - date.to_date).to_i} days ago"
    end
  end

  def format_date(date)
    return unless date

    if date.today?
      date.strftime("%H:%M")
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

    date_today = Date.today
    date_start = Date.parse(datetime)
    number_days = (date_today - date_start).to_i
    number_years = number_days / 365
    number_days_left = number_days % 365
    "#{number_years} year #{number_days_left} days"
  end
end
