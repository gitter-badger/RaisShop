class AddDistincionsToFreq < ActiveRecord::Migration
  def change
    add_column :freqs, :rank, :integer
    add_column :freqs, :list, :string
  end
end
