class CreateProposals < ActiveRecord::Migration[8.1]
  def change
    create_table :proposals, id: :uuid do |t|
      t.uuid :profile_id
      t.uuid :service_request_id
      t.text :message
      t.decimal :price
      t.string :status

      t.timestamps
    end
    add_index :proposals, :profile_id
    add_index :proposals, :service_request_id
  end
end
