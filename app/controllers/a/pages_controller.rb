class A::PagesController < ApplicationController
  def home
    @current_user = current_user

    @inbox_items = [
      { summary: "Referral for Jane Johns", date: "10:45" },
      { summary: "Caller application from Mark Matthews", date: "yesterday" },
      { summary: "Safeguarding flag raised by Poppy Patal", date: "5 days ago" },
      { summary: "Referral for Alisha Anderson", date: "8th Jan" },
    ]

    @waiting_list_count = Callee.with_matches.all.filter(&:waiting?).count
    @pending_matches_count = Match.where(pending: true).count
  end

  def support; end

  def search
    @status ||= :start
    @results ||= []
  end

  def admin
    redirect_to a_admin_admins_path
  end

  def callers
    @callers = Caller.all
    render a_admin_callers_path
  end

  def form_responses; end
end
