class PagesController < ApplicationController
  def home
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
    redirect_to "/admin/admins"
  end

  def admins
    @admins = Admin.all
    render "admin/admins"
  end

  def pod_leaders
    @pod_leaders = PodLeader.all
    render "admin/pod_leaders"
  end

  def callers
    @callers = Caller.all
    render "admin/callers"
  end

  def new_user
    render "admin/new_user"
  end
end
