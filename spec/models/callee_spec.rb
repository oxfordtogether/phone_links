require "rails_helper"

RSpec.describe "Callee", type: :model do
  let!(:callee) { create(:callee, status: :active) }

  let!(:match_1) { create(:match, callee: callee, caller: FactoryBot.create(:caller), status: :active) }
  let!(:match_2) { create(:match, callee: callee, caller: FactoryBot.create(:caller), status: :active) }
  let!(:match_3) { create(:match, callee: callee, caller: FactoryBot.create(:caller), status: :ended) }

  it "ends matches if callee leaves programme" do
    expect(match_1.match_status_changes.count).to eq(1)
    expect(match_2.match_status_changes.count).to eq(1)
    expect(match_3.match_status_changes.count).to eq(1)

    callee.status = :left_programme
    callee.status_change_datetime = Time.now
    callee.save!

    callee.reload
    match_1.reload
    match_2.reload
    match_3.reload

    expect(callee.status).to eq(:left_programme)
    expect(match_1.status).to eq(:ended)
    expect(match_2.status).to eq(:ended)
    expect(match_3.status).to eq(:ended)

    expect(match_1.match_status_changes.count).to eq(2)
    expect(match_2.match_status_changes.count).to eq(2)
    expect(match_3.match_status_changes.count).to eq(1)
  end
end
