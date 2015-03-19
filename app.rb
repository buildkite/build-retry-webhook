require 'rack/parser'
require 'sinatra'
require 'json'
require 'faraday'
require 'faraday_middleware'

# Required
set :webhook_token,    ENV['WEBHOOK_TOKEN']    || raise("no WEBHOOK_TOKEN set")
set :api_access_token, ENV['API_ACCESS_TOKEN'] || raise("no API_ACCESS_TOKEN set")

# Optional
set :buildkite_api_host, ENV['BUILDKITE_API_HOST'] || 'api.buildkite.com'

use Rack::Parser # loads the JSON request body into params

helpers do
  def buildkite_api
    Faraday.new(url: settings.buildkite_api_host) do |faraday|
      faraday.authorization :Bearer, settings.buildkite_access_token
      faraday.request :json
      faraday.response :json
      # faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.use Faraday::Response::RaiseError
    end
  end
end

post "/" do
  halt 401 unless request.env['HTTP_X_BUILDKITE_TOKEN'] == settings.webhook_token

  puts params.inspect # helpful for inspecting incoming webhook requests

  is_finished_build = request.env['HTTP_X_BUILDKITE_EVENT'] == 'build' && params['builds']['finished_at']

  if is_finished_build && (retries = params['build']['meta_data']['retry_builds']) && retries >= 0
    builds_path = URI.parse(params['project']['builds_url']).path

    buildkite_api.post builds_path, commit:  params['commit'],
                                    branch:  params['branch'],
                                    message: params['message'],
                                    env:     params['env'],
                                    meta_data: { retry_builds: retries-1 }
  end

  status 200
end

get "/" do
  "<div style=\"font:24px Avenir,Helvetica;max-width:32em;margin:2em;line-height:1.3\"><h1 style=\"font-size:1.5em\">Huzzah! You’re almost there.</h1><p style=\"color:#666\">Now create a webhook in your <a href=\"https://buildkite.com/\" style=\"color:black\">Buildkite</a> notification settings with this URL, substituting the webhook token from your Heroku app’s config&nbsp;variables:</p><p>#{request.scheme}://#{request.host}/</p></div>"
end
