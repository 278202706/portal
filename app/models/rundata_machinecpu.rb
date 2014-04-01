class RundataMachinecpu < ActiveRecord::Base
  establish_connection :rundata
  self.table_name = "rundata_machinecpu"
end
