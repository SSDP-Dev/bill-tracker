require 'opendata'

class CollectionsController < ApplicationController

    def index
        opendata = OpenData.new(Rails.application.credentials.open_states_api_key) 
        @jurisdictions = opendata.getJurisdictions["data"]["jurisdictions"]["edges"]
    end

    def all
        @collections = Collection.all
    end

    def new 
        CollectionWorker.perform_async(params[:collectionName], params[:jurisdiction], params[:updatedSinceDate])
        flash[:notice] = "We're working on creating your collection. Depending on how large your result is, this might take some time. Check back here for updates"
        redirect_to collections_all_path
    end

    def show
        @collection_id = Collection.find(params[:id]).id
        @collection_length = Collection.find(params[:id]).collection_hash.count
    end
end