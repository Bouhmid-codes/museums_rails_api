class MuseumsController < ApplicationController
  def index
    # Get the latitude and longitude from the query parameters
    response = handle_api_request(params[:lat], params[:lng])
    # Create a hash to store the museums
    museums = {}

    # Loop through the museums and store them in the hash
    response['features'].each do |museum|
      post_code = find_post_code(museum['context'])
      museums[post_code] ||= []
      museums[post_code] << museum['text']
    end

    # Render the hash as JSON
    render json: museums
    # render json: response['features']
  end

  private

  def handle_api_request(lat, lng)
    api_key = ENV['MAPBOX_API_KEY']
    # Mapbox API request
    url = "https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json?proximity=#{lng},#{lat}&access_token=#{api_key}"
    response = RestClient.get(url)
    # returns a parse response
    JSON.parse(response)
  end

  def find_post_code(context)
    # Find the postcode in the context array
    context.select { |item| item['id'].include?('postcode') }.first['text']
  end
end
