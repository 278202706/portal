module AdaccountHelper

  def addorg admin, result, email
    org = admin.organization
    @estr=email
    @pos=@estr.index('@')
    @orgname=@estr[0, @pos]+"-org"
    org.name=@orgname.to_s
    org.users = [result]
    @back=org.create!
    return @back
  end

  def adaddorg admin, result, orgn
    org = admin.organization
    org.name= orgn
    org.users = [result]
    @back=org.create!
    return @back
  end

  def addspc admin, result
    create_space admin, result, "developer"
    #create_space admin,result,"production"
    #create_space admin,result,"staging"
  end

  def create_space admin, result, spcname
    space=admin.space
    org=result.organizations[0]
    space.organization=org
    space.name=spcname.to_s
    space.create!
    space.add_manager result
    space.add_developer result
    space.add_auditor result
  end


end
