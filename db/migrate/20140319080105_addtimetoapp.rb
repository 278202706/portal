class Addtimetoapp < ActiveRecord::Migration
  def change
    add_column :apps, :startime, :datetime
  end
end
