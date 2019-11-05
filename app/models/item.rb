class Item < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :bid_by,
        class_name: 'Item',
        join_table: :trades,
        foreign_key: :item_id,
        association_foreign_key: :bid_by_item_id
    has_and_belongs_to_many :bid_for,
        class_name: 'Item',
        join_table: :trades,
        foreign_key: :bid_by_item_id,
        association_foreign_key: :item_id
    validates :description, length: { maximum: 1000 }
    validates :name, length: { maximum: 100 }
end
