class StorefrontController < ApplicationController
  before_action :set_user_currencies
  before_action :set_player, only: [:ships, :modules, :crew, :consumables]


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
    player_id = params[:player_id]

    unless player_id
      render json: { status: 'error', message: 'Player ID is missing.' }, status: :unprocessable_entity
      return
    end

    player = current_user.players.find_by(id: player_id)
    unless player
      render json: { status: 'error', message: 'Player not found.' }, status: :unprocessable_entity
      return
    end

    # Check if the player has enough currency
    if currency == 'gold' && current_user.gold >= item.cost
      player.gold -= item.cost
      save_purchase(item, 'gold', player)
    elsif currency == 'shards' && current_user.shards >= item.cost
      current_user.shards -= item.cost
      save_purchase(item, 'shards', player)
    else
      render json: { status: 'error', message: 'Not enough currency to purchase this item.' }, status: :unprocessable_entity
    end
  end

  def save_purchase(item, currency, player)
    player_item = player.player_items.find_or_initialize_by(store_item: item)
    player_item.quantity ||= 0
    player_item.quantity += 1

    ActiveRecord::Base.transaction do
      player.save! # Save the player's updated gold
      current_user.save! # Save the user's updated shards
      player_item.save! # Save the purchased item
    end

    render json: {
      status: 'success',
      new_gold: player.gold,
      new_shards: current_user.shards,
      item: { id: item.id, title: item.title, quantity: player_item.quantity }
    }
  rescue => e
    render json: { status: 'error', message: "Purchase failed: #{e.message}" }, status: :unprocessable_entity
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

  def set_player
    @player = current_user.players.first # Adjust logic if multiple players are supported
    unless @player
      redirect_to root_path, alert: "Player not found"
    end
  end

  # Set the user's current gold
  def set_user_currencies
    if current_user
      @player = current_user.players.last

      if @player
        @gold = @player.gold
      else
        @gold = 0
      end

      @shards = current_user.shards
    else
      @gold = 0
      @shards = 0
    end
  end

end
