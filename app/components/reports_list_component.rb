class ReportsListComponent < ViewComponent::Base
  delegate :icon, to: :helpers
  delegate :format_date, :format_datetime, to: :helpers

  def initialize(reports:)
    @reports = reports
  end
end
