class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :comment
      t.integer :stars
      t.boolean :helpful

      t.timestamps
    end
  end
end
