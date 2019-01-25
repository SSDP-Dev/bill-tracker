require 'opendata'

class CollectionWorker
    include Sidekiq::Worker
    sidekiq_options retry: false
    
    # Sidekiq perform method 
    def perform(name, jurisdiction, updatedSince)
        headers = { "X-API-KEY" => Rails.application.credentials.open_states_api_key, "Content-type" => "application/json" }
        result = OpenData.paginate(headers, jurisdiction, updatedSince)
        collection = Collection.create(name: name, collection_hash: result)
    end
  end