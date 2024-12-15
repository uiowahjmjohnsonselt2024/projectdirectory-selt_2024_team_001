class PlayersController < ApplicationController
  before_action :set_server, except: [:inventory]
  before_action :set_player, only: [:update_position, :current_position, :inventory]

  # Show the game grid
  def game_view
    @grid = build_grid
  end

  # Generate a story using the OpenAI API
  def generate_story
    @player = current_user.players.last
    @server = @player&.server

    unless @player && @server
      render json: { success: false, error: "Player or server not found." }, status: :not_found
      return
    end

    # Find the grid tile based on the player's position
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
    inventory_description = inventory_items.any? ? "The player has the following items: #{inventory_items.join(', ')}." : "The player has no items in their inventory."

    # Generate the prompt based on the grid tile's weather, environment, and inventory
    prompt = <<~PROMPT
    Write a short sci-fi story based on a player exploring a planet with #{grid_tile.weather} weather and a #{grid_tile.environment_type} environment. 
    #{inventory_description}
  PROMPT

    # Call the OpenAI service
    service = OpenaiService.new(prompt: prompt, type: 'text')
    response = service.call

    story = response.dig("choices", 0, "message", "content") || "No story generated."

    # Generate a random amount of gold between 10 and 100
    gold_amount = rand(10..100)

    render json: { success: true, story: story, gold: gold_amount }
  rescue StandardError => e
    Rails.logger.error "Error generating story: #{e.message}"
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end





  def inventory
    @player_items = @player.player_items.includes(:store_item)
    render 'menus/inventory'
  end




  # Fetch the current position of the player
  def current_position
    render json: { success: true, position: { row: @player.row, column: @player.column } }
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  # Move the player to a specific tile
  def update_position
    position_params = params.require(:player).permit(:row, :column)
    target_row = position_params[:row].to_i
    target_column = position_params[:column].to_i

    if @player.move_to(target_row, target_column, current_user)
      render json: { success: true, message: "Player successfully moved to (#{target_row}, #{target_column})!" }, status: :ok
    else
      render json: { success: false, error: @player.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

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

    # Add the gold to the player's total and save
    @player.gold += gold_amount

    if @player.save
      new_gold = @player.gold
      render json: { success: true, message: "#{gold_amount} gold added to your inventory!", new_gold: @player.gold }
    else
      render json: { success: false, error: @player.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error "Error collecting gold: #{e.message}"
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end



  # Add the gold to the player's total and save
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



  private

  # Prepares the grid with the player's position
  def build_grid
    return [] unless @player # Return an empty grid if no player is found

    (0..5).map do |row|
      (0..5).map do |column|
        {
          row: row,
          column: column,
          is_current: row == @player.row && column == @player.column
        }
      end
    end
  end
  def set_server
    @server = Server.find_by(id: params[:server_id])
    Rails.logger.debug "set_server: @server = #{@server.inspect}"
    unless @server
      render json: { success: false, error: "Server not found." }, status: :not_found
    end
  end



    def set_player
      @player = Player.find_by(id: params[:id])

      if @player.nil?
        render json: { success: false, error: "Player not found." }, status: :not_found
      end
    end


