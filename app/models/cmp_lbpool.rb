class CmpLbpool < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_lbpool"
  self.inheritance_column = nil
end
