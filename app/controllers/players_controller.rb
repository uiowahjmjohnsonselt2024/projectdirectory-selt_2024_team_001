class PlayersController < ApplicationController
  before_action :set_server, except: [:inventory]
  before_action :set_player, only: [:update_position, :current_position, :inventory]

  # PATCH /servers/:server_id/players/:id/update_position
  def update_position
    new_row = params[:player][:row]
    new_column = params[:player][:column]

    if @player.update(row: new_row, column: new_column)
      # Broadcast the position update via ActionCable
      ActionCable.server.broadcast(
        "server_#{@server.id}_channel",
        { message: "#{current_user.email} moved to row #{new_row}, column #{new_column}" }
      )
      render json: { success: true, message: "Player moved successfully." }, status: :ok
    else
      render json: { success: false, message: @player.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # Generate a story using the OpenAI API
  def generate_story
    @player = current_user.players.last
    @server = @player&.server

    unless @player && @server
      render json: { success: false, error: "Player or server not found." }, status: :not_found
      return
    end

    grid_tile = @server.grid_tiles.find_by(row: @player.row, column: @player.column)
    if grid_tile.nil?
      render json: { success: false, error: "Grid tile not found for player's position." }, status: :unprocessable_entity
      return
    end

    # Fetch the player's inventory items
    inventory_items = @player.player_items.includes(:store_item).map do |player_item|
      "#{player_item.quantity}x #{player_item.store_item.title}"
    end

    # Format the inventory description
    inventory_description = if inventory_items.any?
                              "The player has the following items: #{inventory_items.join(', ')}."
                            else
                              "The player has no items in their inventory."
                            end

    # Generate the prompt based on the grid tile's weather, environment, and inventory
    prompt = <<~PROMPT
      Write a short sci-fi story based on a player exploring a planet with #{grid_tile.weather} weather and a #{grid_tile.environment_type} environment.
      #{inventory_description}
    PROMPT

    # Call the OpenAI service
    service = OpenaiService.new(prompt: prompt, type: 'text')
    response = service.call

    story = response.dig("choices", 0, "message", "content") || "No story generated."
    gold_amount = rand(10..100)

    render json: { success: true, story: story, gold: gold_amount }
  rescue StandardError => e
    Rails.logger.error "Error generating story: #{e.message}"
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  # Collect gold for the player
  def collect_gold
    @player = current_user.players.last

    if @player.nil?
      render json: { success: false, error: "Player not found." }, status: :not_found
      return
    end

    gold_amount = params[:gold].to_i
    if gold_amount <= 0
      render json: { success: false, error: "Invalid gold amount." }, status: :unprocessable_entity
      return
    end

    @player.gold += gold_amount
    if @player.save
      render json: { success: true, message: "#{gold_amount} gold added to your inventory!", new_gold: @player.gold }
    else
      render json: { success: false, error: @player.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error "Error collecting gold: #{e.message}"
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  # Ping players on a specific tile
  def ping_players
    permitted = ping_players_params
    row = permitted[:row]
    column = permitted[:column]

    unless row.present? && column.present?
      render json: { success: false, message: "Row and column parameters are required." }, status: :bad_request
      return
    end

    grid_tile = @server.grid_tiles.find_by(row: row, column: column)
    unless grid_tile
      render json: { success: false, message: "Grid tile not found at the specified coordinates." }, status: :not_found
      return
    end

    players_on_tile = @server.players.where(row: row, column: column).includes(:user)
    response_data = {
      target_tile: {
        row: grid_tile.row,
        column: grid_tile.column,
        weather: grid_tile.weather,
        environment_type: grid_tile.environment_type,
        image_url: grid_tile.image_url
      },
      players_on_tile: players_on_tile.map { |player| { id: player.id, email: player.user.email, row: player.row, column: player.column } }
    }

    current_player_on_tile = players_on_tile.find { |p| p.user_id == current_user.id }
    if current_player_on_tile
      response_data[:current_player] = {
        id: current_player_on_tile.id,
        email: current_user.email,
        row: current_player_on_tile.row,
        column: current_player_on_tile.column
      }
    end

    ActionCable.server.broadcast(
      "tile_#{row}_#{column}_channel",
      { message: "#{current_user.email} pinged the tile!" }
    )

    render json: { success: true, data: response_data }, status: :ok
  rescue => e
    Rails.logger.error "Error in ping_players: #{e.message}"
    render json: { success: false, message: "An unexpected error occurred." }, status: :internal_server_error
  end

  # Inventory action
  def inventory
    @player_items = @player.player_items.includes(:store_item)
    render 'menus/inventory'
  end

  private

  def ping_players_params
    params.permit(:row, :column)
  end

  # Set server based on :server_id or :id parameter
  def set_server
    server_id = params[:server_id] || params[:id]
    @server = Server.find_by(id: server_id)
    unless @server
      render json: { success: false, error: "Server not found." }, status: :not_found
    end
  end

  # Set player based on :id parameter (player id) within the server
  def set_player
    @player = @server.players.find_by(id: params[:id])
    unless @player
      render json: { success: false, error: "Player not found for this server." }, status: :not_found
    end
  end
end
