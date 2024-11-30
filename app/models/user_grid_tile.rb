class UserGridTile < ApplicationRecord
  belongs_to :user
  belongs_to :grid_tile
end
