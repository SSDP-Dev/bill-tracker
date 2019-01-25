class OpenData
    # Set attribute accessor
    attr_accessor :token

    def initialize(token)
        @url = 'https://openstates.org/graphql'
        @token = token
    end

    # Instance query method
    # Supply the headers, using instance variable token 
    # Supply the body, using GraphQL
    def query(headers, body) 
        # Format the body as a query in proper JSON
        body = { query: body }.to_json
        # Make the call using HTTParty
        # Store the response in response 
        response = HTTParty.post(
            @url, 
            :headers => headers,
            :body => body)
        # Return the parsed response
        return response.parsed_response
    end

    # Get the most current hash of Jurisdictions from Open States 
    def getJurisdictions 
        headers = { "X-API-KEY" => @token, "Content-type" => "application/json" }
        body = %{ {jurisdictions{edges {node {id name}}}} } 
        jurisdictions = self.query(headers, body)   
        return jurisdictions            
    end

    # Query constructor method 
    def self.construct_query(jurisdiction, date = Date.today, cursor = "")
        query = %{
        { 
            bills (first: 100, jurisdiction: \"#{jurisdiction}\", updatedSince: \"#{date}\", after: \"#{cursor}\") { 
                edges { 
                    node { 
                        id
                        title 
                        identifier
                        legislativeSession {
                            identifier
                            jurisdiction {
                                name
                            }
                        }
                        sponsorships {
                            name 
                            primary
                        }
                    } 
                } 
                pageInfo {
                    hasNextPage
                    endCursor
                    }
                totalCount 
                } 
            }
        }
        return query
    end

    # Query the Open Graph endpoint
    def self.query(headers, body)
        url = 'https://openstates.org/graphql'
        # Make the request, store it in response 
        response = HTTParty.post(
            url, 
            :headers => headers,
            :body => body)
        return response.parsed_response
    end
    
    # Pagination method 
    def self.paginate(headers, jurisdiction, date, billHash = {}, cursor = "", iteration = 1)
        # Make the query body using the supplied cursor
        body = {query: OpenData.construct_query(jurisdiction, date, cursor) }.to_json
        # Make the initial request 
        # Query the Open States database
        response = OpenData.query(headers, body)
        # Grab important data
        totalCount = response["data"]["bills"]["totalCount"]
        hasNextPage = response["data"]["bills"]["pageInfo"]["hasNextPage"]
        endCursor = response["data"]["bills"]["pageInfo"]["endCursor"]
        bills = response["data"]["bills"]["edges"]

        # Process the data from the request in the hash 
        bills.each do |bill|
            bill = bill["node"]
            bill_id = bill["id"]
            bill_state = bill["legislativeSession"]["jurisdiction"]["name"]
            bill_identifier = bill["identifier"]
            bill_title = bill["title"]
            bill_session = bill["legislativeSession"]["identifier"]
            bill_sponsors = bill["sponsorships"]
            billHash[bill_id] = {"id": bill_id, "title": bill_title, "identifier": bill_identifier, "state": bill_state, "session": bill_session}
        end    
        # If there's another page, go again 
        if hasNextPage 
            sleep(3)
            puts "Moving on to page " + (iteration + 1).to_s
            paginate(headers, jurisdiction, date, billHash, endCursor, (iteration + 1))
        else
            "Finished with: " + billHash.count.to_s + " entries"
            return billHash
        end
    end
end