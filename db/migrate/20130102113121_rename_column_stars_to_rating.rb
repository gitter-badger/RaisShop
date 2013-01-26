class RenameColumnStarsToRating < ActiveRecord::Migration
  def up
    rename_column :reviews, :stars, :rating
  end

  def down
    rename_column :reviews, :rating, :stars
  end
end
