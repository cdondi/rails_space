class AuthorizationToken < ActiveRecord::Migration
  def change
    add_column :users, :authorization_token, :string
  end
end
