class RundataApp < ActiveRecord::Base
 establish_connection :rundata
 self.table_name = "rundata_app"
end
