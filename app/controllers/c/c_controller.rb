class C::CController < ApplicationController
  layout "c/layouts/authorized"

  before_action :set_fetcher

  private

  def set_fetcher
    @fetcher = if @is_admin
                  admin = Admin.find(session[:admin_id])
                  C::CallerDataFetcher.new(admin: admin)
                else
                  # if no caller_id in session this will throw RecordNotFound
                  caller_record = Caller.find(session[:caller_id])
                  C::CallerDataFetcher.new(caller: caller_record)
                end
  end
end
