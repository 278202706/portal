class AddsizeToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :hascode, :string
  end
end
