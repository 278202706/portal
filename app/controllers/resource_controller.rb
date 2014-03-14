class ResourceController < ApplicationController
  include ResourceHelper
  def dashboard
  end

  def software
  end

  def virtualmac
  end

  def network
  end

  def softintro
    @softid=params[:id]
  end

  def softnow
    @softid=params[:id]
    @softtype=params[:id]
  end

  def crebusact      #创建业务账号
    userid=params[:useremail]   #"abc@ebupt.com"
    busname=params[:busname]  #"test"
    type=params[:type]   #"1"
    status=params[:status]   #"1"
    @result=sendcrebusact userid,busname,type,status
    puts @result.to_s+"-----------------------------------------"
    redirect_to :controller => "resource", :action => "business",:id => @result   #创建成功跳转 id为业务账号的ownerid
  end

  def business
    owner_owner=params[:id]
    params[:owner]=owner_owner
    params[:_inner] = true
    owneraccount = Iaas::CmpOwnerController.new
    owneraccount.params = params
    @business_system = owneraccount.detail
  end

  def unitcontainer

  end

  def deletecontainer   #删除已有容器
    redirect_to :controller => "resource", :action => "business",:id => "123"   #删除容器成功跳转 id为业务账号的ownerid
  end

  def unitvirmac

  end

  def releaseip
    flag=0
    if flag=1
      redirect_to :controller => "resource", :action => "network",:response=>"success"
    else
      redirect_to :controller => "resource", :action => "network",:response=>"failure"
    end

  end

  def crenewmode
    flag=0
    if flag=1
      redirect_to :controller => "resource", :action => "softintro",:id=>"1",:response=>"success"
    else
      redirect_to :controller => "resource", :action => "softintro",:id=>"1",:response=>"failure"
    end
  end

  def softinstall
    flag=0
    if flag=1
      redirect_to :controller => "resource", :action => "softnow",:id=>"1",:response=>"inssuccess"
    else
      redirect_to :controller => "resource", :action => "softintro",:id=>"1",:response=>"insfailure"
    end
  end

  def crecontainer
    ownername=params[:containername]
    subnetid=params[:subnetid]
    maxservernum=params[:maxservernum]
    description=params[:description]
    @result=sendcrecontainer ownername,subnetid,maxservernum,description
    redirect_to :controller => "resource", :action => "business",:id => @result
  end

  def crestorage
    storageName=params[:storagename]
    storageNet=params[:storagenetwork]
    description=params[:stodescription]
    storagelevel=params[:storagelevel]
    if storagelevel=="1"
      tier="0"
      raid="4"
    else
      tier="2"
      raid="5"
    end
    tierOpen=params[:tieropen]
    owner=params[:owner]
    resourceType=params[:resourcetype]
    capacity=params[:storagesize]
    @result=sendcrestorage storageName,storageNet,tier,raid,tierOpen,owner,capacity,description
    redirect_to :controller => "resource", :action => "business",:id => @result
  end

end
