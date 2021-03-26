class C::CallerDataFetcher
  def initialize(admin: nil, caller: nil)
    @admin = admin
    @caller = caller
  end

  def caller(caller_id)
    if @admin.present?
      Caller.find(caller_id)
    else
      Caller.where(id: @caller.id).find(caller_id)
    end
  end

  def matches(caller_id)
    caller(caller_id) unless @admin.present?

    Match.for_caller(caller_id).live
  end

  def all_reports(caller_id)
    matches(caller_id).map(&:reports).flatten
  end

  def match(match_id)
    if @admin.present?
      Match.find(match_id)
    else
      Match.for_caller(@caller.id).live.find(match_id)
    end
  end
end
