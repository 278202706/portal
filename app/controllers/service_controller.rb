# encoding: utf-8
class ServiceController < ApplicationController
  include ServiceHelper
  include HomeHelper
  def market
    curemail=session[:useremail]
    @serinsts=Serviceinst.where({:username=>curemail}).all
    @userclient=session[:userclient]
    total_service=@userclient.organizations[0].quota_definition.total_services
    if @serinsts.length.to_i < total_service.to_i
      @permisson="ok"
    else
      @permisson="no"
    end
  end

  def applylist
    @userclient=session[:userclient]
    curemail=session[:useremail]
    @account=Account.find_by_email curemail
    @oklists=Servicelist.where({:userguid=>@account.guid,:active=>true}).all
    @waitlists=Servicelist.where({:userguid=>@account.guid,:active=>false,:isrej=>"no"}).all
    @rejlists=Servicelist.where({:userguid=>@account.guid,:active=>false,:isrej=>"yes"}).all
  end

  def manage
    @userclient=session[:userclient]
    curemail=session[:useremail]
    @account=Account.find_by_email curemail
    @serinsts=Serviceinst.where({:username=>curemail}).all
  end

  def deleteser
    @userclient=session[:userclient]
    begin
    @serinst=Serviceinst.find_by_id params[:serid]
    @ses=@userclient.service_instances_by_name @serinst.name
    @ses.each do |se|
      if se.guid==@serinst.serviceguid
        @thisser=se
      end
    end
    @bindings=@thisser.service_bindings
    @bindings.each do |binding|
      @app = binding.app
      @app.unbind @thisser
    end
    @thisser.delete!
    log="用户删除服务"+@serinst.name+",服务类型为"+@serinst.sertype
    user=session[:useremail]
    createlog user,log
    @serlist=Servicelist.where({:username=>@serinst.username,:name=>@serinst.name}).first
    @serlist.isdelete="yes"
    @serlist.save
    @serinst.destroy
    rescue
    end
    redirect_to :controller=>"service",:action=>"manage"
  end

  def apmysql

  end

  def addmysql
    @userclient=session[:userclient]
    curemail=session[:useremail]
    @account=Account.find_by_email curemail
    @sername=params[:sername]
    type=params[:mysqltype]
    if type=="1"
      @planid=0
      @service=@userclient.services[0]
      an_list=Servicelist.new(
          :userguid=>@account.guid,
          :username=>@account.email,
          :name=>@sername,
          :type=>@service.label.to_s,
          :plan=>@planid,
          :apply_at=>Time.now,
          :active=>false,
          :isrej=>"no")
      an_list.save
      @serint=@userclient.managed_service_instance
      @serint.name=@sername
      @serint.space= @userclient.organizations[0].spaces[0]
      @serint.service_plan= @service.service_plans[@planid.to_i]
      @serint.create!
      an_inst=Serviceinst.new(
          :approvetime=>Time.now,
          :userguid=>@account.guid,
          :username=>@account.email,
          :serviceguid=>@serint.guid,
          :name=>@sername,
          :version=>@service.version,
          :sertype=>@service.label.to_s,
          :provider=>@service.provider,
          :plan=>@planid,
          :org=>@userclient.organizations[0].name,
          :space=>@userclient.organizations[0].spaces[0].name)
      an_inst.save
      an_list.approve_at=an_inst.approvetime
      an_list.active=true
      an_list.save
      log="用户申请服务"+@serint.name+",服务类型为"+an_inst.sertype+",等待管理员审核"
      user=session[:useremail]
      createlog user,log
      log="管理员批准账号"+an_list.username+"的服务申请，编号为"+an_list.id.to_s
      user="admin"
      createlog user,log
      log="用户申请服务"+@serint.name+",服务类型为"+an_inst.sertype+",获得管理员批准"
      user=session[:useremail]
      createlog user,log
    else
      @planid=1
      @service=@userclient.services[0]
      an_list=Servicelist.new(
          :userguid=>@account.guid,
          :username=>@account.email,
          :name=>@sername,
          :type=>@service.label.to_s,
          :plan=>@planid,
          :apply_at=>Time.now,
          :active=>false,
          :isrej=>"no")
      an_list.save
      log="用户申请服务"+@serint.name+",服务类型为"+@serint.sertype+",等待管理员审核"
      user=session[:useremail]
      createlog user,log
    end
    redirect_to :controller=>"service",:action=>"applylist"
  end

  def apfilestorage

  end

  def apmessage

  end

  def viewmysql
    @userclient=session[:userclient]
    curemail=session[:useremail]
    @account=Account.find_by_email curemail
    sername=params[:name]
    @serinst=Serviceinst.where({:name=>sername,:org=>@account.organization}).first
    @ses=@userclient.service_instances_by_name sername
    @ses.each do |se|
      if se.guid==@serinst.serviceguid
        @thisser=se
      end
    end
    @serlist=Servicelist.where({:name=>sername,:username=>curemail,:type=>@serinst.sertype}).first
  end

  def viewfilestorage

  end

  def viewmessage
    @msgtype=params[:type]
  end

  def viewmsgqunfa

  end

  def applyfile
    @servicename=params[:servicename]
    @type=params[:filetype]


      @A=1

    require 'net/http'
    #url = URI.parse("http://10.1.29.121:8000/apply")
    #res=Net::HTTP.post_form(url,'disk'=>'64')
    #res.use_ssl = true
    #puts res.body
    #@response=res.body

    @url = URI.parse("http://192.168.0.121:8000/apply")
    req = Net::HTTP::Post.new(@url.path)
    req.set_form_data({'disk'=>'64'})
    http = Net::HTTP.new(@url.host, @url.port)

    #@response = http.request(req)

      #require 'open-uri'
      #url="http://192.168.0.121:8000/data"
      #content=open(url).read
      #@response=JSON.parse(content)

  end

  def getfileinfo

    require 'rubygems'
    require 'net/dav'
    dav = Net::DAV.new("http://192.168.0.121:3000/", :curl => false)
    dav.verify_server = false
    dav.credentials('4171af72ac9b4a3db19553346887ccd4','beeccaac04b946a3bc22d4ccc4479ca2')
    fileinfo||=[]

    dav.find('',:recursive=>true,:suppress_errors=>true) do | item |
      items={}
      name=item.url.to_s.split("/")[-1]
      items[:name]=name
      items[:url]= item.url.to_s
      if item.type.to_s=="file"
        items[:type]="item"
      else
        items[:type]="folder"
      end
      items[:size]=item.size.to_s
      parent=item.url.to_s.split("/")[-2]
      if parent=="192.168.0.121:3000"
        items[:parentnum]=1
        items[:parent]={"1"=>"/"}
      else
        tmpnum=0
        item.url.to_s.each_byte do |i|
          tmpnum=tmpnum+1 if i==47
        end
        items[:parentnum]=tmpnum-2
        abcd={}
        if item.type.to_s=="file"
          for i in 2..tmpnum-1
            if  item.url.to_s.split("/")[-i]=="192.168.0.121:3000"
              abcd[(tmpnum-i).to_s]="/"
            else
              abcd[(tmpnum-i).to_s]=item.url.to_s.split("/")[-i]
            end
          end
        else
          for i in 2..tmpnum-2
            if  item.url.to_s.split("/")[-i]=="192.168.0.121:3000"
              abcd[(tmpnum-i).to_s]="/"
            else
              abcd[(tmpnum-i).to_s]=item.url.to_s.split("/")[-i]
            end
          end
        end
        items[:parent]=abcd
      end
      fileinfo<<items
    end



    json_hash=fileinfo
    jsonpcallback = params['jsonpcallback']
    if jsonpcallback
      #content_type :js
      @traces="#{jsonpcallback}(#{json_hash.to_json})"
    else
      #content_type :js
      @traces=Yajl::Encoder.encode(json_hash, :pretty => true, :terminator => "\n")
      #        @traces=json_hash.to_json
    end
    respond_to do |format|
      format.json { render :json => @traces }
    end


  end

  def authented
    type = params[:type]
    value = params[:value]
    ret = nil
    ret = Serviceinst.find_by_name(value)  if type == "sername"
    ret={:res=>"valid"} if ret==nil

    #jsonpcallback = params['jsonpcallback']
    @res="#{ret.to_json}"
    respond_to do|format|
      format.json {render :json=>@res}
    end
  end

end
