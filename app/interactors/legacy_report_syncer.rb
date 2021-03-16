require "google_drive"

class LegacyReportSyncer
  def initialize(legacy_pod_id, google_sheet_id, worksheet_index: 0, timestamp_format: "%m/%d/%Y %H:%M:%S")
    @legacy_pod_id = legacy_pod_id
    @google_sheet_id = google_sheet_id
    @worksheet_index = worksheet_index
    @timestamp_format = timestamp_format
  end

  def load_legacy_reports_data
    headers = worksheet.rows[0]
    raw_data = worksheet.rows[1..]
    @data = raw_data.map { |d| Hash[headers.zip d] }
  end

  attr_reader :legacy_pod_id, :google_sheet_id, :worksheet_index, :data, :timestamp_format

  def session
    credentials = if ENV["GOOGLE_DRIVE_CLIENT_SECRET_CONFIG"]
                    StringIO.new(ENV["GOOGLE_DRIVE_CLIENT_SECRET_CONFIG"])
                  else
                    StringIO.new(Rails.application.credentials.google_drive_client_secret_config.to_json)
                  end

    @session ||= GoogleDrive::Session.from_service_account_key(credentials)
  end

  def worksheet
    @worksheet ||= session.spreadsheet_by_key(google_sheet_id).worksheets[worksheet_index]
  end

  def sync
    existing_reports = Report.where(legacy_pod_id: legacy_pod_id)

    data = load_legacy_reports_data

    data.each do |record|
      begin
        # ignore invalid timestamps
        timestamp = DateTime.strptime(record["Timestamp"], timestamp_format)
      rescue Date::Error
        next
      end

      same_report = existing_reports.filter { |r| r.created_at == timestamp && existing_reports }
      next if same_report.count != 0

      Report.create!(
        created_at: timestamp,
        legacy_caller_email: record["Email Address"] || record["Email address"],
        legacy_caller_name: record["Name & Surname"] || record["Your name"],
        legacy_callee_name: record["Name of person you called "] || record["The person you rang "],
        legacy_time_and_date: record["Time and date of phone call "] || record["Date and time"],
        legacy_time: record["Time of phone call "],
        legacy_date: record["Date of phone call "],
        legacy_duration: record["Length of call"],
        summary: record["Brief summary of the conversation"] || record["Short description of your conversation "] || record["Brief summary of the call"],
        concerns: record["Concerns"],
        legacy_pod_id: legacy_pod_id,
      )
    end
  end
end
