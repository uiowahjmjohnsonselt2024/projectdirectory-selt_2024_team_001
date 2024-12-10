require 'stripe'
class ChargesController < ApplicationController
  rescue_from Stripe::CardError, Stripe::InvalidRequestError, with: :catch_exception
  before_action :set_params

  def create
    amount_cents = (@amount * 100).to_i

    # Source: 'tok_visa' is a token provided by the stripe API for testing purposes
    charge = Stripe::Charge.create(amount: (amount_cents), source: 'tok_visa', currency: @currency)

    #flash[:notice] = charge[:paid] == true ? success_message(charge) : failure_message

    if charge.paid
      current_user.shards ||= 0
      current_user.shards += @shards

      if current_user.save
        flash[:notice] = success_message(charge)
      else
        flash[:alert] = "Payment succeeded, but we couldn't update your shard balance. Please contact support."
      end
    else
      flash[:alert] = failure_message
    end
    redirect_back fallback_location: 'main_game_screen'
  end

  private

  #set_params works to set those values shown by errors provided by the Stripe API
  def set_params
    #@card_number = params[:card_number] || 0
    #@card_month = params[:month] || 0
    #@card_year = params[:year] || 0
    #@cvc = params[:cvc] || 0
    #@amount = params[:amount]&.to_i || 0
    #
    @amount = params[:amount]&.to_f || 0
    @currency = params[:currency] || 'usd'
    #raise ArgumentError, "Invalid currency" unless %w[usd eur gbp jpy cad].include?(@currency)
    raise ArgumentError, "Amount must be greater than 0" if @amount <= 0

    @card_number = params[:card_number] || ''
    @card_month = params[:month] || ''
    @card_year = params[:year] || ''
    @cvc = params[:cvc] || ''

    @shards = (@amount / 0.75).floor
  end

  def stripe_token
    Stripe::Token.create(card: { number: @card_number, exp_month: @card_month, exp_year: @card_year, cvc: @cvc })
  end

  def catch_exception(exception)
    flash[:alert] = exception.message
    redirect_back fallback_location: root_path
  end

  def success_message(charge)
    "Your payment for #{@shards} has been successfully processed and added to your new total #{current_user.shards} shards.
     You can take your receipt from here: #{charge[:receipt_url]}"
  end

  def failure_message
    "We are sorry. We are unable to proceed with your request. Please try again later."
  end
end
