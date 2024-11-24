class ServersController < ApplicationController
  before_action :set_server, only: [:show, :edit, :update, :destroy, :add_user, :grid]

  # GET /servers
  # List all servers
  def index
    @servers = Server.all
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
    @server = Server.new(server_params)

    if @server.save
      flash[:success] = "Server created successfully!"
      redirect_to @server
    else
      flash[:error] = "Failed to create server."
      render :new
    end
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
    user = User.find(params[:user_id])

    if @server.users.include?(user)
      flash[:error] = "User is already a member of this server."
    else
      @server.users << user
      user_server = UserServer.find_by(user: user, server: @server)
      user_server.update!(grid_cell: @server.grid_cells.find_by(row: 1, column: 1)) # Assign starting tile
      flash[:success] = "User added to server!"
    end

    redirect_to @server
  end

  # GET /servers/:id/grid
  # View the grid of the server
  def grid
    @grid_cells = @server.grid_cells.order(:row, :column)
    @users_on_grid = @grid_cells.includes(:users)
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
