class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.string :petkind
      t.string :name
      t.text :description
      t.string :image_url
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
