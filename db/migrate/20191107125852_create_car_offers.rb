class CreateCarOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :car_offers do |t|
      t.string :title
      t.text :description
      t.float :price

      t.timestamps
    end
  end
end
