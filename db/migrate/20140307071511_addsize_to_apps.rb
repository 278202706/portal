class AddsizeToApps < ActiveRecord::Migration
  def change
    add_column :apps, :hascode, :string
  end
end
