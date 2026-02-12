class CreateProlifeCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :prolife_categories, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.references :category, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
