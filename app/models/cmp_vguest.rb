class CmpVguest < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_vguest"
  self.inheritance_column = nil
end
