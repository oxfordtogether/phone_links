class SearchComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  def initialize(status:, results:)
    @status = status
    @results = results
  end
end
