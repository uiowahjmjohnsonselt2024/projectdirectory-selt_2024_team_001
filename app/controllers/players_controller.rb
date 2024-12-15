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

    # Generate the prompt based on the grid tile's weather and environment
    prompt = "Write a short sci-fi story based on a player exploring a planet with #{grid_tile.weather} weather and #{grid_tile.environment_type} environment."

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
      render 'menus/inventory'  # Explicitly render the correct view
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
    @player.gold += gold_amount
    @player.save!

    render json: { success: true, message: "#{gold_amount} gold added to your inventory!" }
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
    @player = @server.players.find_by(id: params[:id])
    Rails.logger.debug "set_player: @player = #{@player.inspect}"
    unless @player
      render json: { success: false, error: "Player not found for this server." }, status: :not_found
    end
  end




end
