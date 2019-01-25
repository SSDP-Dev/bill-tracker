class ApiController < ApplicationController
    def index
        render :json => Bill.all
    end

    def collection 
        @collection = Collection.find(params[:id])
        render json: @collection
    end
end