class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.text :category
      t.text :name
      t.integer :user_id
      t.timestamp :date_added

      t.timestamps
    end
  end
end
