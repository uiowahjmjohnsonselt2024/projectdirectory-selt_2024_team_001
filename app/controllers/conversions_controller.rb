class ConversionsController < ApplicationController

  #def convert
  # amount = params[:amount].to_f
  # from_currency = params[:from_currency]
  # to_currency = params[:to_currency]

   # Initialize the converter
  #  converter = CurrencyConverter.new(from_currency)

  # begin
  #    rates = converter.fetch_rates
  #    if rates[to_currency]
  #      converted_amount = (amount * rates[to_currency]['value']).round(2)
  #      render json: { converted_amount: converted_amount, rate: rates[to_currency]['value'] }
  #   else
  #      render json: { error: "Conversion rate for #{to_currency} is not available" }, status: :unprocessable_entity
  #    end
  #  rescue StandardError => e
  #    Rails.logger.error "Currency conversion failed: #{e.message}"
  #    render json: { error: "An error occurred while fetching currency rates." }, status: :internal_server_error
  # end
  #end

  def convert_to_usd
    amount = params[:amount].to_f
    currency = params[:currency]

    if currency.present? && amount > 0
      converter = CurrencyConverter.new(currency)
      rates = converter.fetch_rates
      usd_rate = rates['USD']['value'] if rates['USD']

      if usd_rate
        converted_amount = (amount * usd_rate).round(2)
        render json: { converted_amount: converted_amount }
      else
        render json: { error: "Unable to fetch USD rate" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid input" }, status: :unprocessable_entity
    end
  end

end

