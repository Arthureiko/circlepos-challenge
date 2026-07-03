require "net/http"
require "json"

# Server-side client for the CirclePOS challenge-only API.
# Runs on the backend to avoid the API's missing CORS headers.
class CirclePosClient
  class Error < StandardError; end

  BASE_URL = "https://challenge.circlepos.com/api/challenge".freeze

  def stores
    get("/stores")
  end

  def filters
    get("/filters")
  end

  def monthly_comparison(store_id:, months: 24, category_id: nil, channel: nil)
    get("/monthly-comparison", {
      store_id: store_id,
      months: months,
      category_id: category_id,
      channel: channel
    }.compact)
  end

  private

  def get(path, params = {})
    uri = URI("#{BASE_URL}#{path}")
    uri.query = URI.encode_www_form(params) if params.any?

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 8) do |http|
      http.get(uri)
    end

    raise Error, "CirclePOS API returned HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue JSON::ParserError, Net::OpenTimeout, Net::ReadTimeout, SocketError, Errno::ECONNREFUSED => e
    raise Error, "Could not reach the CirclePOS API (#{e.class})"
  end
end
