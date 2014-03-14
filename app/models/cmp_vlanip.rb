class CmpVlanip < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_vlanip"
  self.inheritance_column = nil
end
