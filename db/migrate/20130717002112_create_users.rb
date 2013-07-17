class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :username
      t.text :bio
      t.string :url
      t.string :city
      t.string :state
    end
  end
   
  def down
    drop_table :users
  end
end