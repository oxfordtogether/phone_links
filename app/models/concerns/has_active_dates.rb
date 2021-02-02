module HasActiveDates
  extend ActiveSupport::Concern

  def active_on?(date)
    start_date <= date && (end_date.nil? || end_date >= date)
  end

  def active?
    active_on?(Date.today)
  end

  def no_longer_active_on?(date)
    !!end_date && end_date < date
  end

  def no_longer_active?
    no_longer_active_on?(Date.today)
  end

  def not_yet_active_on?(date)
    start_date > date
  end

  def not_yet_active?
    not_yet_active_on?(Date.today)
  end

  included do
    scope :active_on, ->(date) { where("start_date <= ? AND (end_date >= ? OR end_date is NULL)", date, date) }
    scope :no_longer_active_on, ->(date) { where("end_date < ?", date) }
    scope :not_yet_active_on, ->(date) { where("start_date > ?", date) }
  end
end
