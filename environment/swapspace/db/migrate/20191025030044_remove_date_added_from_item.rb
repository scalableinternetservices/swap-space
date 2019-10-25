class RemoveDateAddedFromItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :date_added, :timestamp
  end
end
