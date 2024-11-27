require 'rails_helper'

RSpec.describe GridTile, type: :model do
  describe "associations" do
    it { should belong_to(:server) }
  end

  describe "validations" do
    it { should validate_presence_of(:row) }
    it { should validate_presence_of(:column) }
    it { should validate_presence_of(:weather) }
    it { should validate_presence_of(:environment_type) }
  end

  describe "custom validations or methods" do
    before do
      # Disable the initialize_grid callback
      Server.skip_callback(:create, :after, :initialize_grid)
    end

    after do
      # Re-enable the initialize_grid callback after the test
      Server.set_callback(:create, :after, :initialize_grid)
    end

    let(:server) { create(:server, status: "Open") }

    it "raises an error when creating a duplicate row/column for the same server" do
      create(:grid_tile, server: server, row: 1, column: 1) # Create the first tile

      expect {
        create(:grid_tile, server: server, row: 1, column: 1) # Attempt to create a duplicate
      }.to raise_error(ActiveRecord::RecordInvalid, /A tile already exists for this row and column on this server/)
    end
  end
end
