class Item < ApplicationRecord
    belongs_to :user
    validates :description, length: { maximum: 1000 }
    validates :name, length: { maximum: 100 }
end
