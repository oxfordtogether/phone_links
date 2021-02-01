require "rails_helper"

RSpec.describe "Person", type: :model do
  let!(:person) { create(:person) }

  it "works" do
    expect(Person.count).to eq(1)
  end
end
