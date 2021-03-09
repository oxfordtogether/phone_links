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

    # J
    syncer = LegacyReportSyncer.new(1, "1CHF4p6p1dJE5nyJ9geOJDuPgiSCdctFU_Bo9KxtE0pE", worksheet_index: 0, timestamp_format: "%d/%m/%Y %H:%M:%S")
    syncer.sync

    # L
    syncer = LegacyReportSyncer.new(8, "1w4Vnah0rXUkc8fLo9zOdBxRLdKlR8ePaIYPfqZdidNM", worksheet_index: 2, timestamp_format: "%d/%m/%Y %H:%M:%S")
    syncer.sync

    # K
    syncer = LegacyReportSyncer.new(7, "1mTh90tQ1azqcPyRcseyavOhE2zql59bKgEiJkudzb8A", worksheet_index: 0, timestamp_format: "%d/%m/%Y %H:%M:%S")
    syncer.sync

    # F
    syncer = LegacyReportSyncer.new(6, "1x7kLT-D7slLTP_EhbCMbRUQQw1uapIPDYxX0pLZcLdA", worksheet_index: 0, timestamp_format: "%d/%m/%Y %H:%M:%S")
    syncer.sync
  end
end
