class LegacyReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    # CC
    syncer = LegacyReportSyncer.new(5, "1TYKCA3AOCzUK6-OjKC7TxfJDNCiCsHN3o-GTcGiaFvQ")
    syncer.sync

    # N
    syncer = LegacyReportSyncer.new(2, "1iK7rJOhlf-t4LFuqpfz3LEhAMwM0l2rjouBkaWn3b8U", worksheet_index: 2, timestamp_format: "%d/%m/%Y %H:%M:%S")
    syncer.sync
  end
end
