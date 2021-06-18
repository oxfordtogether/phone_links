FactoryBot.define do
  factory :pod_leader, class: PodLeader do
    person factory: :person

    status { PodLeader.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }
    status_change_datetime { FFaker::Time.between(Date.today - 1.year, Date.today) }

    report_received_email_updates { false }
  end
end
