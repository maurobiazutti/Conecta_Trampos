class AddTitleToServiceRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :service_requests, :title, :string
  end
end
