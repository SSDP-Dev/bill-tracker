require 'httparty'
class BillsController < ApplicationController
    def index
        url = 'https://openstates.org/graphql'
        headers = { "X-API-KEY" => Rails.application.credentials.open_states_api_key, "Content-type" => "application/json" }
        @cursor = params[:cursor]
        @date = params[:updatedSinceDate]
        direction = params[:commit]
        body = index_query_constructor(@cursor, direction, @date)
            response = HTTParty.post(
                url, 
                :body => body,
                :headers => headers)
            @response = response.parsed_response
    end

    def activity
        @active_bills = []
        @bills = Bill.all
        @date = params[:updatedSinceDate]
        @bills.each do |b|
            if b.get_active(@date)
                @active_bills.push(b)
            end
        end
    end

    def show
        url = 'https://openstates.org/graphql'
        headers = { "X-API-KEY"  => Rails.application.credentials.open_states_api_key, "Content-type" => "application/json" }
        @id = params[:id]
        body = {query: "{bill: bill(id: \"#{@id}\") {id \
            subject \
            identifier \
            title \
            classification \
            updatedAt \
            createdAt \
            legislativeSession { \
                identifier \
                jurisdiction { \
                    name \
                } \
            } \
            actions { \
                date \
                description \
                classification \
            } \
            votes { \
                edges { \
                  node { \
                    counts { \
                        option \
                        value \
                      } \
                    votes { \
                      option \
                      voterName \
                      note \
                    } \
                  } \
                } \
              } \
            documents { \
                date \
                note \
                links { \
                    url \
                } \
            } \
            versions { \
                date \
                note \
                links { \
                    url \
                } \
            } \
            sources { \
                url \
                note \
            } \
        } \
        }"}.to_json
        response = HTTParty.post(
            url, 
            :body => body,
            :headers => headers)
        @response = response.parsed_response
    end

    def bill_follow
        if params[:commit] == "Follow"
            @bill = Bill.create(
            bill_identifier: params[:bill_identifier],
            bill_title: params[:bill_title],
            bill_session: params[:bill_session],
            bill_jurisdiction: params[:bill_jurisdiction],
            bill_id: params[:bill_id]
            )
            if @bill.valid?  
            @bill.save!
            flash[:notice] = "Successfully followed bill"
            redirect_to "/following"
            else 
            flash[:notice] = "Something went wrong"
            redirect_to "/following"
            end
        else
            Bill.find_by(bill_id: params[:bill_id]).destroy!
            flash[:notice] = "Successfully unfollowed bill"
            redirect_to "/following"
        end
      end

    def following 
    @bills = Bill.all
    end

    private 
    def index_query_constructor(cursor, direction, date)
        if (cursor and direction == "Next")
            body = {query: "{bills(updatedSince : \"#{date}\", first: 100, after: \"#{cursor[:end]}\") \
                { edges \
                    { node \
                        { title \
                            id \
                            identifier \
                            legislativeSession { \
                                identifier \
                                jurisdiction { \
                                    name \
                                } \
                            } \
                            sponsorships { \
                                name \
                                primary \
                            } \
                        } \
                    } \
                    totalCount \
                    pageInfo { \ 
                        hasNextPage \
                        hasPreviousPage \
                        endCursor \
                        startCursor \
                        } \
                    }\
                }"}.to_json
            return body
        elsif (cursor and direction == "Previous")
            body = {query: "{bills(updatedSince : \"#{date}\", last: 100, before: \"#{cursor[:start]}\") \
            { edges \
                { node \
                    { title \
                        id \
                        identifier \
                        legislativeSession { \
                            identifier \
                            jurisdiction { \
                                name \
                            } \
                        } \
                        sponsorships { \
                            name \
                            primary \
                        } \
                    } \
                } \
                totalCount \
                pageInfo { \ 
                    hasNextPage \
                    hasPreviousPage \
                    endCursor \
                    startCursor \
                    } \
                }\
            }"}.to_json
        return body
        else
        body = {query: "{bills(updatedSince : \"#{date}\", first: 100) \
        { edges \
            { node \
                { title \
                    id \
                    identifier \
                    legislativeSession { \
                        identifier \
                        jurisdiction { \
                            name \
                        } \
                    } \
                    sponsorships { \
                        name \
                        primary \
                    } \
                } \
            } \
            totalCount \
            pageInfo { \ 
                hasNextPage \
                hasPreviousPage \
                endCursor \
                startCursor \
                } \
            }\
        }"}.to_json
        return body
        end
    end
end