require 'stripe'
class ChargesController < ApplicationController
  rescue_from Stripe::CardError, Stripe::InvalidRequestError, with: :catch_exception
  before_action :set_params

  def create
    if flash[:alert].present?
      redirect_back fallback_location: 'shard_purchase'
      return
      end

    if @currency == 'JPY'
      amount_cents = (@amount).to_i
    else
      amount_cents = (@amount * 100).to_i
    end

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

  #set_params works to set those values, shown by errors provided by the Stripe API
  def set_params
    @amount = params[:amount]&.to_f || 0
    @currency = params[:currency] || ''
    @converted_amount = params[:hidden_converted_amount]&.to_f || 0
    @card_number = params[:card_number] || ''
    @card_month = params[:month] || ''
    @card_year = params[:year] || ''
    @cvc = params[:cvc] || ''

    flash[:alert] ||= []

    validate_amount
    validate_currency_existence
    validate_currency
    validate_card_number
    validate_card_expiration
    validate_cvc

    flash[:alert] = flash[:alert].join(' ') if flash[:alert].any?

    if(@currency == 'USD')
      @shards = (@amount / 0.75).floor
    else
      @shards = (@converted_amount / 0.75).floor
    end
  end

  def validate_amount
    flash[:alert] << "| Amount must be greater than 0 |" if @amount <= 0
  end

  def validate_currency_existence
    if @currency == ''
      flash[:alert] <<"| Select a Currency |"
    end
  end

  def validate_currency
    if @currency != 'USD' && @currency != ''
      if @converted_amount <= 0
      flash[:alert] << "| Converted Amount must be calculated for non-USD currencies |"
      end
    end
  end

  def validate_card_number
    flash[:alert] << "| Credit card number must be 16 digits |" if @card_number.length != 16
  end

  def validate_card_expiration
    if @card_year.to_i < Date.today.year % 100 || (@card_year.to_i == Date.today.year % 100 && @card_month.to_i < Date.today.month)
      flash[:alert] << "| Card is expired |"
    end
  end

  def validate_cvc
    flash[:alert] << "| CVC must be a 3-digit number |" if @cvc.length != 3
  end




  def stripe_token
    Stripe::Token.create(card: { number: @card_number, exp_month: @card_month, exp_year: @card_year, cvc: @cvc })
  end

  def catch_exception(exception)
    flash[:alert] = exception.message
    redirect_back fallback_location: 'shard_purchase'
  end

  def success_message(charge)
    "Your payment for #{@shards} has been successfully processed and added to your new total #{current_user.shards} shards.
     You can take your receipt from here: #{charge[:receipt_url]}"
  end

  def failure_message
    "We are sorry. We are unable to proceed with your request. Please try again later."
  end
end
