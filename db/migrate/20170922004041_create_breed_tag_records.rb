class CreateBreedTagRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :breed_tag_records do |t|
      t.integer :breed_id, null: false
      t.integer :tag_id, null: false

      t.timestamps
    end

    # I indexed [tag_id, breed_id] rather than vice versa because in the specs
    # there appear to be more tags than breeds
    add_index :breed_tag_records, [:tag_id, :breed_id], unique: true
  end
end
