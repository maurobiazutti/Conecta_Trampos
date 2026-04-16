class CreateServiceRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :service_requests, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :category_id
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
