class C::CallerDataFetcher
  def initialize(caller)
     @caller = caller
  end

  def matches
    Match.for_caller(@caller.id).live
  end

  def reports
    matches = Match.for_caller(@caller.id)
    Report.where(match_id: matches.ids)
  end

  def reports_for_match(match)
    match.reports
  end

  def match(match_id)
    Match.for_caller(@caller.id).live.find(match_id)
  end
end
