require "rails_helper"

RSpec.describe "Caller", type: :model do
  let!(:caller) { create(:caller, status: :active) }

  let!(:match_1) { create(:match, caller: caller, callee: FactoryBot.create(:callee), status: :active) }
  let!(:match_2) { create(:match, caller: caller, callee: FactoryBot.create(:callee), status: :active) }
  let!(:match_3) { create(:match, caller: caller, callee: FactoryBot.create(:callee), status: :ended) }

  it "ends matches if caller leaves programme" do
    expect(match_1.match_status_changes.count).to eq(1)
    expect(match_2.match_status_changes.count).to eq(1)
    expect(match_3.match_status_changes.count).to eq(1)

    caller.status = :left_programme
    caller.status_change_datetime = Time.now
    caller.save!

    caller.reload
    match_1.reload
    match_2.reload
    match_3.reload

    expect(caller.status).to eq(:left_programme)
    expect(match_1.status).to eq(:ended)
    expect(match_2.status).to eq(:ended)
    expect(match_3.status).to eq(:ended)

    expect(match_1.match_status_changes.count).to eq(2)
    expect(match_2.match_status_changes.count).to eq(2)
    expect(match_3.match_status_changes.count).to eq(1)
  end
end
