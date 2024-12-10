require 'net/http'
require 'json'

class CurrencyConverter

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_rates(base_currency = 'USD')
    url = "#{BASE_URL}?apikey=#{@api_key}&base_currency=#{base_currency}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    parsed_response = JSON.parse(response)

    if parsed_response['data']
      parsed_response['data'] # Contains the exchange rates
    else
      raise "Error fetching currency rates: #{parsed_response['message']}"
    end
  end
end
