class Serviceinst < ActiveRecord::Base
  attr_accessible :approvetime,:userguid, :username, :serviceguid, :name ,:version,:sertype,:provider,:plan,:org,:space
end
