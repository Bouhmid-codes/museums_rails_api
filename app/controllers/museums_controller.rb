class MuseumsController < ApplicationController
  def index
    return unavailable_params_error unless params[:lat] && params[:lng]

    response = handle_api_request(params[:lat], params[:lng])

    # Render JSON
    render json: response
  end

  private

  def unavailable_params_error
    render json: { error: 'params unavailable' }
  end

  def handle_api_request(lat, lng)
    api_key = ENV['MAPBOX_API_KEY']
    error_response = { error: 'Oops! Cannot find Museums in this area!'}
    # Mapbox API request
    url = "https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json?proximity=#{lng},#{lat}&access_token=#{api_key}"
    RestClient.get(url) do |response, _, _|
      response.code == 200 ? build_json(JSON.parse(response)) : error_response
    end
  end

  def find_post_code(context)
    # Find the postcode
    context.select { |item| item['id'].include?('postcode') }.first['text']
  end

  def build_json(response)
    museums = {}

    # Loop through the museums from the response and store them with their post codes in the hash
    response['features'].each do |museum|
      post_code = find_post_code(museum['context'])
      museums[post_code] ||= []
      museums[post_code] << museum['text']
    end
    museums
  end
end
