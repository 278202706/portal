module ResourceHelper
  def sendcrebusact userid,busname,type,status
    #require 'net/http'
    #require 'uri'
    #url = URI("http://127.0.0.1:1238/iaas/cmp_owner/create")
    #response = Net::HTTP.post_form(url,"externalId" => userid, "ownerName" =>busname,"type" =>type, "status" => status)
    #@response=response.body
    #puts @response+"----------------------------------------------------"
    #return @response
    owneraccount = Iaas::CmpOwnerController.new
    params[:externalId]=userid
    params[:ownerName]=busname
    params[:type]=type
    params[:status]=status
    params[:_inner]= true
    owneraccount.params = params
    result=owneraccount.create
    return result
  end

  def sendcrecontainer ownername,subnetid,maxservernum,description
    ownercontainer = Iaas::CmpOwnercontainerController.new
    params[:ownerName]=ownername
    params[:subnetName]=subnetid
    params[:capacity]=maxservernum
    params[:description]=description
    params[:_inner]= true
    ownercontainer.params = params
    result=ownercontainer.create
    return result
  end

  def sendcrestorage storageName,storageNet,tier,raid,tierOpen,owner,capacity,description
    ownerstorage = Iaas::CmpStoragevolumeController.new
    params[:storageName]=storageName
    params[:storageNet]=storageNet
    params[:tier]=tier
    params[:raid]=raid
    params[:tierOpen]=tierOpen
    params[:owner]=owner
    params[:capacity]=capacity
    params[:description]=description
    params[:_inner]= true
    ownerstorage.params = params
    result=ownerstorage.create
    return result
  end

end
