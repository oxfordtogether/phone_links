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
      date.strftime("%H:%M")
    elsif date.year == Date.today.year
      date.strftime("#{date.day.ordinalize} %b")
    else
      date.strftime("#{date.day.ordinalize} %b %Y")
    end
  end
end
