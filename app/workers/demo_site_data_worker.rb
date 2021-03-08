class DemoSiteDataWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    if ENV["demo"] == "true"
      seeder = DemoSiteDataSeeder.new
      seeder.empty_db
      seeder.seed
    end
  end
end
