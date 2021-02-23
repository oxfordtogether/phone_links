module ApplicationHelper
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
end
