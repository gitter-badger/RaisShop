class CreateFreqs < ActiveRecord::Migration
  def change
    create_table :freqs do |t|
      t.string :word

      t.timestamps
    end
  end
end
