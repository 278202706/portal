class RundataMachinedisk < ActiveRecord::Base
  establish_connection :rundata
  self.table_name = "rundata_machinedisk"
end
