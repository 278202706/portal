module HomeHelper
  def createlog user,log
    @newaplog=Userlog.new
    @newaplog.username=user
    @newaplog.log=log
    @newaplog.save
  end
end
