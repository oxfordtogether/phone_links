class SearchReflex < ApplicationReflex
  def perform(query = "")
    if query.empty?
      @status = :start
    else
      @status = :search_complete
      @results = SearchCache.get_people(query, limit: 10)
    end
  end
end
