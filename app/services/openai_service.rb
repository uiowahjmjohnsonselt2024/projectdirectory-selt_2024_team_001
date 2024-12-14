require 'open-uri'

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
        model: "gpt-4",
        messages: [{ role: "user", content: @prompt }],
        temperature: 0.7
      }
    )
  end

  def call_image_api
    response = OpenAIClient.images.generate(
      parameters: {
        prompt: @prompt,
        n: 1,
        size: "512x512"
      }
    )

    image_url = response.dig("data", 0, "url")
    save_image_from_url(image_url) if image_url
  rescue StandardError => e
    Rails.logger.error "OpenAI image generation failed: #{e.message}"
    nil
  end

  def save_image_from_url(image_url)
    filename = "generated_images/#{SecureRandom.uuid}.png"
    filepath = Rails.root.join("public", filename)

    URI.open(image_url) do |image|
      File.open(filepath, 'wb') do |file|
        file.write(image.read)
      end
    end

    "/#{filename}" # Return the relative path for serving
  rescue StandardError => e
    Rails.logger.error "Failed to save image: #{e.message}"
    nil
  end
end
