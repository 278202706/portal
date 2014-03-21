# encoding: utf-8
class AdaccountController < ApplicationController
  include AdaccountHelper
  include LoginHelper
  def dashboard
    @orgs=Orglocal.all
    @userclient=session[:userclient]
  end

  def manage
	  @orgs=Orglocal.all
  end

  def unitaccount
    id=params[:id]
    @thisorg=Orglocal.find_by_id id
    @userclient=session[:userclient]
    @org=@userclient.organization_by_name @thisorg.name
    @account=Account.new
    @thisaccount=Account.find_by_organization @org.name
    @apps=App.find_by_org    @org.name
    @serinsts=Serviceinst.find_by_org @org.name
  end

  def addaccount
	
    @userclient=session[:userclient]
    puts @userclient
    @name=params[:org_name]
    @memory=params[:quota_memory]
    @sernum=params[:quota_service]
    @quota=@userclient.quota_definition
    @quota.name=@name.to_s
    @quota.total_services=@sernum.to_i
    @quota.memory_limit=@memory.to_i
    @quota.manifest.values[0]["total_routes"]=100
    @quota.non_basic_services_allowed=false
    @qrepeat=0
    @quotas=@userclient.quota_definitions
    @quotas.each do |quo|
      if quo.name==@name
        @qrepeat=1
        break
      end
    end
    puts "aa"+@name.to_s+@memory.to_s+@sernum.to_s
    puts "----------------------------------ok"
    if @qrepeat==0
      begin
        @quota.create!
        puts "----------------------------------ok"
          #act = "管理员创建权限"+@name+"成功"
          #createlog act
      rescue Exception => e
        puts e
          #act = "管理员创建权限"+@name+"失败"+e.to_s
          #createlog act
      end
    else
      #act = "管理员创建权限"+@name+"失败，权限名称已存在"
      #createlog act
    end
    @error=params[:error]
    @orgs=@userclient.organizations
    @orgname=params[:org_name]
    @repeat = 0
    @orgs.each do |s|
      if s.name == @orgname
        @repeat = 1
        break
      end
    end
    if @repeat==0
      org=@userclient.organization
      org.name=@orgname.to_s
      org.quota_definition=@quota
      org.create!
      an_org=Orglocal.new(
      :name => @orgname.to_s,
      :guid => org.guid)
      an_org.save
      #space=@userclient.space
      #space.organization=org
      #space.name=@spacename
      #space.create!
      act = "管理员创建组织"+@orgname+"成功"
      #createlog act
      redirect_to :controller => "adaccount", :action => "manage"
    else
      act = "管理员创建组织"+@orgname+"失败"
      #createlog act
      redirect_to :controller => "adaccount", :action => "manage", :error => "namerecur"
    end
  end

  def addtoorg
		@account = Account.new(params[:account])
		@spacename=params[:space_name]
		puts @account.organization
    @admin=session[:userclient]
		respond_to do |format|
			if @account.save
        @admin=target
        @admin.login({:username=>"admin",:password=> "admin"})
        begin
        @result=@admin.register(@account.email, @account.password)
        rescue Exception => e
          puts e
        end
        @account.guid=@result.guid
        @account.username=@account.email
        @account.space=@spacename
        @account.hascode='0'
        @account.organization=params[:organization]
        @account.save
        @org=@admin.organization_by_name @account.organization.to_s
        @result.organizations=[@org]
        @result.update!
        @org.users=[@result]
        create_space @admin, @result, @spacename.to_s
        #act="管理员成功创建组织"+@org.name+"的账号"
       # createlog act
        format.html { redirect_to :controller => "adaccount", :action => "unitaccount", :id => params[:orgid] }
        format.json
			else
				#act="管理员创建组织"+@org.name+"的账号失败"
				#createlog act
				format.html { redirect_to :controller => "adaccount", :action => "unitaccount", :id => params[:orgid] }
				#format.html { redirect_to :controller=>"admin",:action=>"orgslist" }
				format.json { render json: @account.errors, status: :unprocessable_entity }
			end
		end
	end
  
  def changecodenum
    id= params[:accountid]
    account1=Account.find_by_id id
    account1.codenum=params[:codesize]
    account1.save
    redirect_to :controller => "adaccount", :action => "unitaccount", :id => params[:orgid]


  end

  def changequota

    @userclient=session[:userclient]
    @quotaname=params[:quotaname]
    @mem=params[:quota_memory]
    @tolser=params[:quota_service]
    @quotanow=@userclient.quota_definition_by_name @quotaname
    @quotanow.memory_limit=@mem.to_i
    @quotanow.total_services=@tolser.to_i
    @quotanow.update!

    redirect_to :controller => "adaccount", :action => "unitaccount", :id => params[:orgid]

  end



  def authented
    type = params[:type]
    value = params[:value]
    ret = nil
    ret = Account.find_by_email(value)  if type == "accemail"
    ret = Orglocal.find_by_name(value)  if type == "orgname"
    ret={:res=>"valid"} if ret==nil

    #jsonpcallback = params['jsonpcallback']
    @res="#{ret.to_json}"
    respond_to do|format|
      format.json {render :json=>@res}
    end
  end

end
