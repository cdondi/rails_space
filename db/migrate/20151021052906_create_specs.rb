class CreateSpecs < ActiveRecord::Migration
  def change
    create_table :specs do |t|
      t.integer :user_id, :null => false
      t.string :first_name, :last_name, :occupation, :city, :state, :zip_code, :default => ""
      t.string :gender
      t.date :birthdate
      t.timestamps
    end
  end
end
