class AddCacheCounters < ActiveRecord::Migration[5.1]
  def change
    add_column :breeds, :breed_tag_records_count, :integer
    add_column :tags, :breed_tag_records_count, :integer
  end
end
