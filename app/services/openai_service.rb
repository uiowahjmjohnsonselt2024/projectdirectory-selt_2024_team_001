# app/services/openai_service.rb
class OpenAIService
  def initialize(prompt)
    @prompt = prompt
  end

  def call
    OpenAIClient.chat(
      parameters: {
        model: "gpt-4", # or "gpt-3.5-turbo"
        messages: [{ role: "user", content: @prompt }],
        temperature: 0.7
      }
    )
  rescue => e
    Rails.logger.error("OpenAI API Error: #{e.message}")
    nil
  end
end
