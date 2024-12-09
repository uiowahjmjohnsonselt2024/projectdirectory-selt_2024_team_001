Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe, :publishable_key),
  secret_key: Rails.application.credentials.dig(:stripe, :secret_key)
}

# Verify keys exist
if Rails.configuration.stripe[:publishable_key].nil? || Rails.configuration.stripe[:secret_key].nil?
  Rails.logger.error("Stripe keys are missing!")
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
