class CmpComputepool < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_computepool"
  self.inheritance_column = nil
end
