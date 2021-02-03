class SearchGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create
    copy_file "search.html.erb", "app/views/pages/search.html.erb"

    copy_file "search_spec.rb", "spec/interactors/search_spec.rb"

    copy_file "search_reflex.rb", "app/reflexes/search_reflex.rb"
    copy_file "search_controller.js", "app/javascript/controllers/search_controller.js"

    copy_file "search_cache.rb", "app/interactors/search_cache.rb"
    copy_file "search_cache_refresh.rb", "app/workers/search_cache_refresh.rb"
  end
end
