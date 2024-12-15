class PlayerItemsController < ApplicationController
  before_action :set_player, only: [:index, :create]
  before_action :set_player_item, only: [:update]

  # List all items owned by a player
  def index
    @player_items = @player.player_items.includes(:store_item)
    render json: @player_items.map { |item| item.attributes.merge(store_item: item.store_item) }
  end

  # Add a new item to the player's inventory or update quantity if it already exists
  def create
    store_item = StoreItem.find(params[:store_item_id])

    player_item = @player.player_items.find_or_initialize_by(store_item: store_item)
    player_item.quantity += params[:quantity].to_i

    if player_item.save
      render json: { status: 'success', player_item: player_item }, status: :created
    else
      render json: { status: 'error', message: player_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Update an item in the player's inventory (e.g., change quantity)
  def update
    if @player_item.update(quantity: params[:quantity])
      render json: { status: 'success', player_item: @player_item }
    else
      render json: { status: 'error', message: @player_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Set the player based on the current user
  def set_player
    @player = Player.find_by(user: current_user, server_id: params[:server_id])
    unless @player
      render json: { status: 'error', message: 'Player not found' }, status: :not_found
    end
  end

  # Set the player item for update actions
  def set_player_item
    @player_item = PlayerItem.find(params[:id])
  end
end
