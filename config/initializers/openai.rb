require 'openai'

OpenAIClient = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'] || Rails.application.credentials.dig(:openai, :api_key))
