class AddPgExtentions < ActiveRecord::Migration
  # mistyped name
  def up
    execute "CREATE EXTENSION fuzzystrmatch;"
    execute "create extension pg_trgm"
    execute "create extension hstore"
  end

  def down
    execute "DROP EXTENSION fuzzystrmatch;"
    execute "drop extension pg_trgm"
    execute "drop extension hstore"
  end
end
