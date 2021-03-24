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

    # A
    syncer = LegacyReportSyncer.new(9, "1iyx5BtyiyvBIXlm234p19NQ-SDsUXmdklkOzYf8hrpc", worksheet_index: 0)
    syncer.sync

    # B
    syncer = LegacyReportSyncer.new(10, "1LZqZtwU0a1xuxFeUB7LPuPC-BvKgmhrcs8UG7nDSm0A", worksheet_index: 0)
    syncer.sync

    # E
    syncer = LegacyReportSyncer.new(13, "1hBt7hUBUf5OQ8wcYTsPnLO26Y8IPtDsf-68xOx8WFRU", worksheet_index: 2)
    syncer.sync
  end
end
