class PagesController < ApplicationController
  def home
    @inbox_items = [
      { summary: "Referral for Jane Johns", date: "10:45" },
      { summary: "Caller application from Mark Matthews", date: "yesterday" },
      { summary: "Safeguarding flag raised by Poppy Patal", date: "5 days ago" },
      { summary: "Referral for Alisha Anderson", date: "8th Jan" },
    ]
  end

  def support; end

  def search
    @status ||= :start
    @results ||= []
  end
end
