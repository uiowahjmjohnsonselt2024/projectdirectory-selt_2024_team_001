# config/initializers/openai.rb

Rails.configuration.openai = {
  access_token: Rails.application.credentials.dig(:openai, :api_key)

}

# Verify the access token exists
if Rails.configuration.openai[:access_token].nil?
  Rails.logger.error("OpenAI API key is missing!")
end

# Initialize the OpenAI client
OpenAIClient = OpenAI::Client.new(access_token: Rails.configuration.openai[:access_token])
