class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles, id: :uuid do |t|
      t.text :description
      t.string :phone
      t.boolean :active
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
