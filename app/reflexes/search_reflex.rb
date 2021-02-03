class SearchReflex < ApplicationReflex
  def perform(query = "")
    if query.empty?
      @status = :start
    else
      @status = :search_complete
      @results = SearchCache.get_roles(query, limit: 10)
      puts @results.count
    end
  end
end
