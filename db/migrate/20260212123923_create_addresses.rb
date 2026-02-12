class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :street
      t.string :number
      t.string :neighborhood
      t.string :complement
      t.string :city
      t.string :state
      t.string :cep
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
