class AddTsvectorDetaphoneToProducts < ActiveRecord::Migration
  def up
    execute "ALTER TABLE products ADD COLUMN tsv tsvector"
    #execute <<-QUERY
    #UPDATE products SET tsv = (to_tsvector('english', coalesce("building"."title"::text, '')));
    #QUERY

    execute "CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
              ON products FOR EACH ROW EXECUTE PROCEDURE
              tsvector_update_trigger(tsv, 'pg_catalog.english', title);"
  end

  def down
    execute "drop trigger tsvectorupdate on products"
    execute "alter table products drop column tsv"
  end
end
