class CreateParks < ActiveRecord::Migration[6.0]
  def change
    create_table :parks do |t|
      t.string :name
      t.string :location
      t.string :type
      t.string :rides
      t.integer :user_id
    end
  end
end
