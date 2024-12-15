require 'net/http'
require 'json'

class CurrencyConverter

  def initialize(base_currency = 'USD')
    @base_currency = base_currency
    end

  def fetch_rates(base_currency = 'USD')
    url = "#{CURRENCY_API_BASE_URL}?apikey=#{CURRENCY_API_KEY}&base_currency=#{@base_currency}"
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
