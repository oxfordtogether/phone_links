require "rails_helper"

RSpec.describe "search cache", type: :model do
  let!(:person) { create(:person, first_name: "Joseph", last_name: "Bloggson") }
  let!(:person2) { create(:person, first_name: "Helen", last_name: "Noblog") }
  let!(:person3) { create(:person, first_name: "David", last_name: "Blogblog") }
  let!(:person4) { create(:person, first_name: "David", last_name: "Doesn't match") }

  describe "searching people" do
    before(:each) do
      SearchCache.refresh
    end

    it "can find people using a fragment of the name" do
      expect(SearchCache.get_people_ids("blog").records).to match_array([person.id, person2.id, person3.id])
    end
    it "can limit the number of results" do
      people_ids = SearchCache.get_people_ids("blog", limit: 2)
      expect(people_ids.length).to eq(2)
      expect(people_ids.total_count).to eq(3)
    end
  end

  describe "searching roles" do
    skip "Needs configuring"

    # configure for use case
    let!(:pwd) { create(:person_with_dementia, person: person) }
    let!(:carer) { create(:carer, person: person2) }
    let!(:volunteer) { create(:volunteer, person: person2) }
    let!(:dementia_adviser) { create(:dementia_adviser, person: person3) }

    before(:each) do
      SearchCache.refresh
    end

    it "returns all relevant roles" do
      expect(SearchCache.get_roles("blog").records).to match_array([pwd, carer, volunteer, dementia_adviser])
    end

    it "can limit the number of results" do
      skip "need to redesign search cache to handle this"
      roles = SearchCache.get_roles("blog", limit: 2)
      expect(roles.length).to eq(2)
      # NOTE: 3 people but 4 roles
      expect(roles.total_count).to eq(4)
    end
  end
end
