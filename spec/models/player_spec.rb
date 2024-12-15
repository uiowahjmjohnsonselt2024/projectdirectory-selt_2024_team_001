require 'spec_helper'
require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:server) { create(:server) }
  let(:user) { create(:user, shards: 5) }
  let(:player) { create(:player, user: user, server: server, row: 2, column: 2) }

  before do
    server.grid_tiles.destroy_all
    (0..2).each do |row|
      (0..2).each do |column|
        create(:grid_tile, server: server, row: row, column: column)
      end
    end
  end

  describe "#move_to" do
    context "when the target position is valid" do
      it "moves the player to the target position within one tile" do
        expect(server.grid_tiles.exists?(row: 2, column: 3)).to be_truthy # Ensure target exists
        expect(player.move_to(2, 3, user)).to be_truthy
        player.reload
        expect(player.row).to eq(2)
        expect(player.column).to eq(3)
        expect(user.shards).to eq(5) # No cost for adjacent move
      end

      it "moves the player to a non-adjacent position and deducts shards" do
        expect(server.grid_tiles.exists?(row: 0, column: 0)).to be_truthy
        expect(player.move_to(0, 0, user)).to be_truthy
        player.reload
        expect(player.row).to eq(0)
        expect(player.column).to eq(0)
        expect(user.shards).to eq(4) # Cost is 1 shard for non-adjacent move
      end
    end

    context "when the target position does not exist in the grid" do
      it "does not move the player and adds an error" do
        expect(player.move_to(5, 5, user)).to be_falsey
        expect(player.errors[:base]).to include("Invalid target position. The tile does not exist.")
        player.reload
        expect(player.row).to eq(2)
        expect(player.column).to eq(2)
      end
    end

    context "when the user has insufficient shards for a non-adjacent move" do
      it "does not move the player and adds an error" do
        user.update!(shards: 0)
        expect(server.grid_tiles.exists?(row: 0, column: 0)).to be_truthy
        expect(player.move_to(0, 0, user)).to be_falsey
        expect(player.errors[:base]).to include("Insufficient shards for movement.")
        player.reload
        expect(player.row).to eq(2)
        expect(player.column).to eq(2)
      end
    end

    context "when a transaction fails" do
      it "does not update the player's position or deduct shards" do
        allow(player).to receive(:update!).and_raise(StandardError, "Something went wrong")
        expect(server.grid_tiles.exists?(row: 2, column: 3)).to be_truthy
        expect(player.move_to(2, 3, user)).to be_falsey
        expect(player.errors[:base]).to include("Something went wrong")
        player.reload
        expect(player.row).to eq(2)
        expect(player.column).to eq(2)
        expect(user.shards).to eq(5) # Shards remain unchanged
      end
    end
  end
end
