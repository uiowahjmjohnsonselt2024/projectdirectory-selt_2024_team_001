# app/services/openai_service.rb
class OpenaiService
  def initialize(params)
    @prompt = params[:prompt]
    @type = params[:type] || 'text' # Default to 'text'
  end

  def call
    case @type
    when 'text'
      call_text_api
    when 'image'
      call_image_api
    else
      raise ArgumentError, "Unsupported type: #{@type}"
    end
  end

  private

  def call_text_api
    OpenAIClient.chat(
      parameters: {
        model: "gpt-4", # or "gpt-3.5-turbo"
        messages: [{ role: "user", content: @prompt }],
        temperature: 0.7
      }
    )
  end

  def call_image_api
    OpenAIClient.images.generate(
      parameters: {
        prompt: @prompt,
        n: 1,
        size: "1024x1024" # or other available sizes
      }
    )
  end
end
