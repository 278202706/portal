class CmpVserveradapter < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_vserveradapter"
  self.inheritance_column = nil
end
