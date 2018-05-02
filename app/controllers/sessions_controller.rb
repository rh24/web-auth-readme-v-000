class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    resp = Faraday.get("https://foursquare.com/oauth2/access_token") do |req|
      req.params['client_id'] = ENV['FOURSQUARE_CLIENT_ID']
      req.params['client_secret'] = ENV['FOURSQUARE_SECRET']
      req.params['grant_type'] = 'authorization_code'
      req.params['redirect_uri'] = "http://localhost:3000/auth"
      req.params['code'] = params[:code]
      # If the user accepts, they will be redirected back to your URI with a code. That's where params[:code] comes from.
      # https://YOUR_REGISTERED_REDIRECT_URI/?code=CODE
    end

    # Your server exchanges the code for an access token, which is a response in JSON.
    body = JSON.parse(resp.body)
    session[:token] = body["access_token"]
    redirect_to root_path
  end
end
