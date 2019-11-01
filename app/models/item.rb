class Item < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :trades,
        class_name: 'Item',
        join_table: :trades,
        foreign_key: :item_id,
        association_foreign_key: :bid_by_item_id
end
