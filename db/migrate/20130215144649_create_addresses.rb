class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :full_name
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :country
      t.integer :postcode
      t.string :phone_number
      t.references :user

      t.timestamps
    end
  end
end
