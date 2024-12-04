require 'spec_helper'
require 'rails_helper'

RSpec.describe Server, type: :model do
  describe "callbacks" do
    it "creates a 6x6 grid of grid_cells after creation" do
      server = create(:server)

      expect(server.grid_tiles.count).to eq(36) # 6x6 grid

      # Ensure the grid_cells have correct rows, columns, and default attributes
      expect(server.grid_tiles.pluck(:weather).uniq).to contain_exactly("Clear")
      expect(server.grid_tiles.pluck(:environment_type).uniq).to contain_exactly("Forest")
      expect(server.grid_tiles.pluck(:image_url).uniq).to contain_exactly("default_image.jpg")

      # Verify a specific grid_cell exists (e.g., row 1, column 1)
      expect(server.grid_tiles.find_by(row: 1, column: 1)).to be_present
    end
  end

  # Additional tests can be added here
  describe "Validations" do
    # Placeholder for future validation tests
  end
end
