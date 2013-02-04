class AddPgExtentions < ActiveRecord::Migration
  def up
    execute "create extension fuzzystrmatch"
    execute "create extension pg_trgm"
    execute "create extension hstore"
  end

  def down
    execute "drop extension fuzzystrmatch"
    execute "drop extension pg_trgm"
    execute "drop extension hstore"
  end
end
