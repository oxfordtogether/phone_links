class LegacyReportSyncer
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    syncer = LegacyReportSyncer.new(5, "1TYKCA3AOCzUK6-OjKC7TxfJDNCiCsHN3o-GTcGiaFvQ")
    syncer.sync
  end
end
