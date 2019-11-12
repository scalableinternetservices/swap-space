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

    def popularity
        return bid_by.count
    end

    def traded_item 
        # this should have length one
        traded_items = bid_by.select do |bidder|
            bid_for.include?(bidder)
        end
        return traded_items[0]
    end

    def traded_item_time
        sql = "SELECT created_at FROM trades WHERE item_id = #{id}"
        records_array = ActiveRecord::Base.connection.execute(sql)
        return records_array[0]
    end

    def compare(a, b)
        return a < b ? b : a
    end
end
