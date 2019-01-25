require 'httparty'

class Bill < ApplicationRecord
    validates_uniqueness_of :bill_id

    def get_active(date)
        url = 'https://openstates.org/graphql'
        headers = { "X-API-KEY" => Rails.application.credentials.open_states_api_key, "Content-type" => "application/json" }
        body = {query: "{bill(id : \"#{self.bill_id}\") { updatedAt }}" }.to_json
        response = HTTParty.post(
            url, 
            :headers => headers,
            :body => body)
        response = response.parsed_response
        responseDate = response["data"]["bill"]["updatedAt"].split(' ')[0]
        responseDate = Date.parse(responseDate)
        date = Date.parse(date) unless date.nil?
        # Check if the response date is before the target date 
        # Returns true if there's more recent activityDate than the supplied date
        date < responseDate unless date.nil?
    end
end
