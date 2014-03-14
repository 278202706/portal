class AdserviceController < ApplicationController
  def dashboard
    @userclient=session[:userclient]
    @oklists=Servicelist.where({:active=>true}).all
    @waitlists=Servicelist.where({:active=>false,:isrej=>"no"}).all
    @rejlists=Servicelist.where({:active=>false,:isrej=>"yes"}).all
  end
  def manage
    @userclient=session[:userclient]
    @allsers=Serviceinst.all
  end

  def viewmysql
    @userclient=session[:userclient]
    serid=params[:id]
    @serinst=Serviceinst.where({:id=>serid}).first
    @ses=@userclient.service_instances_by_name @serinst.name
    @ses.each do |se|
      if se.guid==@serinst.serviceguid
        @thisser=se
      end
    end
    @serlist=Servicelist.where({:name=>@serinst.name,:username=>@serinst.username,:type=>@serinst.sertype}).first
  end

  def msgform
    if params[:msgtype]=="day"
    @getaccyear=params[:yearseld]
    @getaccmonth=params[:monthseld]
    @getaccday=params[:dayseld]
    else
      if  params[:msgtype]=="month"
        @getaccyear=params[:yearselm]
        @getaccmonth=params[:monthselm]
      else
        @getaccyear=params[:yearsely]
      end
    end
    @getnowyear=Time.now.year
    if @getaccyear==nil
      @showyear=@getnowyear
    else
      @showyear=@getaccyear
    end
    @getnowmonth=Time.now.strftime("%Y%m")
    if @getaccmonth==nil
      @showmonth=@getnowmonth
    else
      @showmonth=@getaccyear.to_s+@getaccmonth.to_s
    end
    @getnowday=Time.now.strftime("%Y%m%d")
    if @getaccday==nil
      @showday=@getnowday
    else
      @showday=@getaccyear.to_s+@getaccmonth.to_s+@getaccday.to_s
    end
  end
  def accform
    if params[:msgtype]=="day"
      @getaccyear=params[:yearseld]
      @getaccmonth=params[:monthseld]
      @getaccday=params[:dayseld]
    else
      if  params[:msgtype]=="month"
        @getaccyear=params[:yearselm]
        @getaccmonth=params[:monthselm]
      else
        @getaccyear=params[:yearsely]
      end
    end
    @getnowyear=Time.now.year
    if @getaccyear==nil
      @showyear=@getnowyear
    else
      @showyear=@getaccyear
    end
    @getnowmonth=Time.now.strftime("%Y%m")
    if @getaccmonth==nil
      @showmonth=@getnowmonth
    else
      @showmonth=@getaccyear.to_s+@getaccmonth.to_s
    end
    @getnowday=Time.now.strftime("%Y%m%d")
    if @getaccday==nil
      @showday=@getnowday
    else
      @showday=@getaccyear.to_s+@getaccmonth.to_s+@getaccday.to_s
    end
  end

  def rejser
    serlistid=params[:id]
    @serlist=Servicelist.find_by_id serlistid
    @serlist.reject_at= Time.now
    @serlist.isrej="yes"
    @serlist.save
    redirect_to :controller=>"adservice",:action=>"dashboard"
  end

end
