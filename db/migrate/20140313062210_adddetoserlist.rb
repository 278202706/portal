class Adddetoserlist < ActiveRecord::Migration
  def change
    add_column :servicelists, :isdelete, :string
  end
end
