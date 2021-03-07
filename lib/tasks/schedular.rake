desc "Sync legacy reports"
task sync_legacy_reports: :environment do
  LegacyReportWorker.perform_async
end
