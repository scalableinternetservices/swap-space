class AddItemToItemRelation < ActiveRecord::Migration[5.1]
  def change
    create_table :trades, id: false do |t|
      t.integer :item_id
      # descirbe what items used to bid :itme_id
      t.integer :bid_by_item_id
    end

    add_index(:trades, [:item_id, :bid_by_item_id], :unique => true)
    add_index(:trades, [:bid_by_item_id, :item_id], :unique => true)
  end
end
