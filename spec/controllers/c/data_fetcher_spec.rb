require "rails_helper"

RSpec.describe "CallerDataFetcher", type: :helper do
  let!(:admin) { create(:admin, status: "active") }

  let!(:pod) { create(:pod) }

  let!(:caller_1) { create(:caller, status: "active", pod: pod, person: create(:person, auth0_id: '123')) }
  let!(:caller_2) { create(:caller, status: "active", pod: pod, person: create(:person, auth0_id: '123')) }

  let!(:match_1_a) { create(:match, caller: caller_1, callee: create(:callee), status: "active")}
  let!(:match_1_b) { create(:match, caller: caller_1, callee: create(:callee), status: "active")}

  let!(:match_2_a) { create(:match, caller: caller_2, callee: create(:callee), status: "active")}

  let!(:reports) do
    Match.all.each do |match|
      create_list(:report, 2, match: match)
      create_list(:report, 4, legacy_pod_id: match.pod.id, match: nil)
    end
  end

  let!(:callers) { Caller.all }
  let!(:matches) { Match.all }

  it "gives access to everything for admins" do
    Current.person_id = admin.person_id

    fetcher = C::CallerDataFetcher.new(admin: admin)

    expect(fetcher.caller(caller_1.id)).to eq(caller_1)
    expect(fetcher.caller(caller_2.id)).to eq(caller_2)

    expect(fetcher.matches(caller_1.id).count).to eq(2)
    expect(fetcher.matches(caller_2.id).count).to eq(1)

    expect(fetcher.all_reports(caller_1.id).count).to eq(match_1_a.reports.count + match_1_b.reports.count)
    expect(fetcher.all_reports(caller_2.id).count).to eq(match_2_a.reports.count)

    matches.each do |match|
      expect(fetcher.match(match.id)).to eq(match)
    end
  end

  it "restricts access for callers" do
    Current.person_id = caller_1.person_id

    fetcher = C::CallerDataFetcher.new(caller: caller_1)

    expect(fetcher.caller(caller_1.id)).to eq(caller_1)
    expect do
      fetcher.caller(caller_2.id)
    end.to raise_error(ActiveRecord::RecordNotFound)

    expect(fetcher.matches(caller_1.id)).to eq([match_1_a, match_1_b])
    expect do
      fetcher.matches(caller_2.id)
    end.to raise_error(ActiveRecord::RecordNotFound)

    expect(fetcher.all_reports(caller_1.id).count).to eq(match_1_a.reports.count + match_1_b.reports.count)
    expect do
      fetcher.all_reports(caller_2.id)
    end.to raise_error(ActiveRecord::RecordNotFound)

    expect(fetcher.match(match_1_a.id)).to eq(match_1_a)
    expect(fetcher.match(match_1_b.id)).to eq(match_1_b)
    expect do
      fetcher.match(match_2_a.id)
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end
