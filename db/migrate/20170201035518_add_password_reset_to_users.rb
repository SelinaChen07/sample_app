class AddPasswordResetToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :reset_digest, :string
    add_column :users, :reset_send_at, :datetime
  end
end
