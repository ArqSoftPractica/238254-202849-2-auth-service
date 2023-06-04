class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, if_not_exists: true, force: false do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :role, null: false
      t.string :password_digest, null: false
      t.integer :companyId

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
