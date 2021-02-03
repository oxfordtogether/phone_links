class PagesController < ApplicationController
  def home; end

  def support; end

  def search
    @status ||= :start
    @results ||= []
  end
end
