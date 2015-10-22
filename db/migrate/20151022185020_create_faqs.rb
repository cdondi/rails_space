class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.integer :user_id, :null => false
      t.text :bio, :skills, :schools, :companies, :music, :movies, :television, :magazines, :books
      t.timestamps
    end
  end
end
