class CreateAccountsAndUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.timestamps
    end
    add_index :users, "lower(email_address)", unique: true, name: "index_users_on_lower_email_address"

    create_table :accounts do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_index :accounts, "lower(slug)", unique: true, name: "index_accounts_on_lower_slug"

    create_table :memberships do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role, null: false, default: 0
      t.timestamps
    end
    add_index :memberships, %i[account_id user_id], unique: true

    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent
      t.timestamps
    end
  end
end
