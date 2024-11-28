class ServersController < ApplicationController
  before_action :set_server, only: [:show, :edit, :update, :destroy, :add_user, :grid, :game_view]
  skip_before_action :verify_authenticity_token, only: [:add_user_custom, :create]

  def game_view
    # Ensure the user is registered to this server
    unless current_user.servers.include?(@server)
      flash[:error] = "You are not registered to this server."
      redirect_to servers_path
      return
    end

    # Render the game view for the specific server
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
    @grid_cells = @server.grid_cells.order(:row, :column)
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

      flash[:success] = "Server created successfully with ID #{server.id}, and you are now registered to it!"
    else
      flash[:error] = "Failed to create server."
    end

    redirect_to servers_path
  end



  def add_user_custom
    server = Server.find_by(id: params[:server_number])
    if server
      registration = UserServer.find_or_initialize_by(user: current_user, server: server)
      if registration.persisted?
        flash[:error] = "You are already registered to this server."
      else
        registration.save!
        flash[:success] = "You have successfully joined server #{server.id}!"
      end
    else
      flash[:error] = "Server not found."
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
      flash[:success] = "Server updated successfully!"
      redirect_to @server
    else
      flash[:error] = "Failed to update server."
      render :edit
    end
  end

  # DELETE /servers/:id
  # Delete a server
  def destroy
    @server.destroy
    flash[:success] = "Server deleted successfully!"
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
      flash[:error] = "You are already registered to this server."
    else
      registration.save!
      flash[:success] = "You have successfully joined server #{server.server_num}!"
    end

    redirect_to servers_path
  end



  # GET /servers/:id/grid
  # View the grid of the server
  def grid
    @grid_cells = @server.grid_tiles.order(:row, :column)
    @users_on_grid = @grid_tiles.includes(:users)
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
