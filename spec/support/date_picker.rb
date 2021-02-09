module DatePicker
  def date_picker_fill_in(id, date:)
    find("##{id}").click
    first("#date-picker__change-year").click
    first("#date-picker__year-#{date.year}").click
    first("#date-picker__month-#{date.strftime('%b')}").click
    first("#date-picker__day-#{date.day}").click
  end

  def date_picker_expect_value(label, date:)
    if !date
      expect(find_field(label).value).to eq("")
    else
      expect(find_field(label).value).to eq date.strftime("%a #{date.day.ordinalize} %b, %Y")
    end
  end
end

RSpec.configure do |config|
  config.include DatePicker, type: :system
end
