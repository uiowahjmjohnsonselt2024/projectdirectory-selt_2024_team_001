class ServersController < ApplicationController
  before_action :set_server, only: [:show, :edit, :update, :destroy, :add_user, :grid, :game_view]
  skip_before_action :verify_authenticity_token, only: [:add_user_custom, :create]

  def game_view
    unless current_user.servers.include?(@server)
      flash[:alert] = "You are not registered to this server."
      redirect_to servers_path and return
    end

    # Create or fetch the player for the current user
    @player = @server.players.find_or_create_by!(user: current_user) do |player|
      player.row = 0
      player.column = 0
    end

    # Ensure the player's position matches a grid tile
    unless @server.grid_tiles.exists?(row: @player.row, column: @player.column)
      flash[:error] = "Player position is invalid. Resetting to (0,0)."
      @player.update!(row: 0, column: 0)
    end

    session[:return_to] = game_view_server_path(@server)
    render 'game_view'
  end



  # GET /servers
  # List all servers
  def index
    @user_servers = current_user.user_servers.includes(:server) # Registered servers
    @servers = Server.all # All servers
  end




  # GET /servers/:id
  # Show details of a specific server
  def show
    @users = @server.users
    @grid_tiles = @server.grid_tiles.order(:row, :column)
  end

  def createGrid
    # Ensure grid tiles are created only if they don't already exist for the server
    return if @server.grid_tiles.exists?

    # Iterate through rows and columns to create grid tiles
    (0..5).to_a.reverse.each do |row| # Reverse rows for bottom-left `00`
      (0..5).each do |column|
        @server.grid_tiles.create!(
          row: row,
          column: column,
          weather: nil, # Replace with your desired weather value
          environment_type: nil # Replace with your desired environment type
        )
      end
    end
  end

  # GET /servers/new
  # Display the form for creating a new server
  def new
    @server = Server.new
  end

  # POST /servers
  # Create a new server
  def create
    # Create the server with the provided status
    server = Server.new(status: params[:server_status])

    if server.save
      # Automatically register the current user to the newly created server
      UserServer.create!(user: current_user, server: server)

      flash.now[:success] = "Server created successfully with ID #{server.id}, and you are now registered to it!"
    else
      flash.now[:error] = "Failed to create server."
    end

    redirect_to servers_path
  end



  def add_user_custom
    server = Server.find_by(id: params[:server_number])
    if server
      registration = UserServer.find_or_initialize_by(user: current_user, server: server)
      if registration.persisted?
        flash.now[:error] = "You are already registered to this server."
      else
        registration.save!
        flash.now[:success] = "You have successfully joined server #{server.id}!"
      end
    else
      flash.now[:error] = "Server not found."
    end
    redirect_to servers_path
  end



  # GET /servers/:id/edit
  # Display the form for editing a server
  def edit
  end

  # PATCH/PUT /servers/:id
  # Update a server
  def update
    if @server.update(server_params)
      flash.now[:success] = "Server updated successfully!"
      redirect_to @server
    else
      flash.now[:error] = "Failed to update server."
      render :edit
    end
  end

  # DELETE /servers/:id
  # Delete a server
  def destroy
    @server.destroy
    flash.now[:success] = "Server deleted successfully!"
    redirect_to servers_path
  end

  # POST /servers/:id/add_user
  # Add a user to the server
  def add_user
    server = Server.find(params[:id]) # Find the server by ID
    user = User.find(current_user.id) # Find the current user

    # Create the association
    registration = UserServer.find_or_initialize_by(user: user, server: server)

    if registration.persisted?
      flash.now[:error] = "You are already registered to this server."
    else
      registration.save!
      flash.now[:success] = "You have successfully joined server #{server.server_num}!"
    end

    redirect_to servers_path
  end



  # GET /servers/:id/grid
  # View the grid of the server
  def grid
    @grid_tiles = @server.grid_tiles.order(:row, :column)
    @users_on_tiles = @grid_tiles.presence&.includes(:users) || []
    redirect_to servers_path
  end

  private

  # Find a server for specific actions
  def set_server
    @server = Server.find(params[:id])
  end

  # Permit server parameters
  def server_params
    params.require(:server).permit(:server_num, :status)
  end
end
