class StorefrontController < ApplicationController
  before_action :set_user_currencies

  # Ships category
  def ships
    @items = StoreItem.where(category: 'Ship')
  end

  # Modules category
  def modules
    @items = StoreItem.where(category: 'Module')
  end

  # Crew category
  def crew
    @items = StoreItem.where(category: 'Crew')
  end

  # Consumables category
  def consumables
    @items = StoreItem.where(category: 'Consumable')
  end

  # Purchase an item
  def purchase_item
    item = StoreItem.find(params[:item_id])
    currency = params[:currency]

    if currency == 'gold' && current_user.gold >= item.cost
      current_user.gold -= item.cost
      process_purchase(current_user, 'gold')
    elsif currency == 'shards' && current_user.shards >= item.cost
      current_user.shards -= item.cost
      process_purchase(current_user, 'shards')
    else
      render json: { status: 'error', message: 'Not enough currency to purchase this item.' }, status: :unprocessable_entity
    end
  end

  def process_purchase(user, currency)
    if user.save
      render json: { status: 'success', new_gold: user.gold, new_shards: user.shards }
    else
      render json: { status: 'error', message: 'Unable to update balance.' }, status: :unprocessable_entity
    end
  end



  # Update gold via fetch request
  def update_gold
    gold_spent = params[:gold_spent].to_i

    if current_user.nil?
      render json: { status: 'error', message: 'User not logged in.' }, status: :unauthorized
      return
    end

    if current_user.gold >= gold_spent
      current_user.gold -= gold_spent
      if current_user.save
        render json: { status: 'success', new_gold: current_user.gold }
      else
        render json: { status: 'error', message: 'Unable to update gold balance.' }, status: :unprocessable_entity
      end
    else
      render json: { status: 'error', message: 'Not enough gold.' }, status: :unprocessable_entity
    end
  end

  private

  # Set the user's current gold
  def set_user_currencies
    if current_user
      @gold = current_user.gold
      @shards = current_user.shards
    else
      @gold = 0
      @shards = 0
    end
  end
end
