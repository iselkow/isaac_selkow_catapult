class CreateBreeds < ActiveRecord::Migration[5.1]
  def change
    create_table :breeds do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :breeds, :name, unique: true
  end
end
