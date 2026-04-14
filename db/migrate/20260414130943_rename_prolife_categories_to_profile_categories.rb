class RenameProlifeCategoriesToProfileCategories < ActiveRecord::Migration[8.1]
  def change
    rename_table :prolife_categories, :profile_categories
  end
end
