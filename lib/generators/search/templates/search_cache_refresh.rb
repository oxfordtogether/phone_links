class SearchCacheRefresh
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    SearchCache.refresh
  end
end
