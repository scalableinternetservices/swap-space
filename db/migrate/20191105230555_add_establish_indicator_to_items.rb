class AddEstablishIndicatorToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :trade_established, :boolean, :default=>false 
  end
end
