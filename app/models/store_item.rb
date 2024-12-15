# app/models/store_item.rb
class StoreItem < ApplicationRecord
  belongs_to :user, optional: true
  validates :title, :description, :cost, :modifier, :currency, presence: true
end
