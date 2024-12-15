Rails.configuration.currency_api = {
  api_key: Rails.application.credentials.dig(:currency_api, :api_key),
  base_url: 'https://api.currencyapi.com/v3/latest'
}

# Verify that the API key exists
if Rails.configuration.currency_api[:api_key].nil?
  Rails.logger.error("Currency API key is missing! Please check your credentials.")
end

# Make the API configuration easily accessible
CURRENCY_API_KEY = Rails.configuration.currency_api[:api_key]
CURRENCY_API_BASE_URL = Rails.configuration.currency_api[:base_url]