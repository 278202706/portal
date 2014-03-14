# encoding: utf-8
module ApplicationsHelper
   def upcode appname,useremail,tmpfilein,userclient,appguid,version
     @appname=appname
     @useremail=useremail
     tmpfile=tmpfilein
     require 'pathname'
     directory = Pathname.new("#{Rails.root}/public/userdata/"+@useremail)
     directory.mkpath
     zipfilename = UUIDTools::UUID.random_create.to_s + ".zip"
     path = File.join(directory.to_s, zipfilename)
     @zippath=path
     begin
       File.open(path, 'wb') do |f|
         f.write(tmpfile.read)
       end
       dirpath = File.join("#{Rails.root}/public/userdata/"+@useremail, @appname.to_s)
       puts "-----------------------------------------------t"

     @path=dirpath

       if File.directory?(dirpath)
         require "fileutils"
         FileUtils.remove_dir(dirpath)
       end
       Dir.mkdir(dirpath)


       require "rubygems"
       require "zip/zip"
       Zip::ZipFile.open(path) do |zipfile|
         zipfile.each do |zf|
           path=File.join(@path.to_s, zf.name)
           zipfile.extract(zf, path) { true }
         end
       end
       @ababa="success"

     rescue Exception => e
       @ababa="false"
     end

     if @ababa=="success"

       require 'find'
       dirSize = 0
       Find.find(@zippath.to_s) do |f|
         dirSize += File.size(f)
       end


       @appcodes=Appcode.where({username:@useremail}).all
       @sizeofcode=dirSize
       @appcodes.each do |codesize|
         @sizeofcode=@sizeofcode+codesize.size.to_i
       end

       @account=Account.find_by_email @useremail
       @codesize=@account.codenum.to_i*1024*1024
       if @sizeofcode > @codesize

         File.delete(@zippath.to_s)
        return "errcodefull"
       else
=begin
         commd='export BUILDPACK_CACHE="~/build_dir/cache"'
        # @com=`#{commd}`
         @com=system commd
         lang1="~/build_dir/target/dea_ng/buildpacks/vendor/ruby/bin/detect "+@path.to_s
         #@lag1=`#{lang1}`
         @lag1=system lang1
         puts lang1
         puts "----------------------------"
         puts @lag1
         lang2="~/build_dir/target/dea_ng/buildpacks/vendor/java/bin/detect "+@path.to_s
         #@lag2=`#{lang2}`
         @lag2=system lang2
         lang3="~/build_dir/target/dea_ng/buildpacks/vendor/nodejs/bin/detect "+@path.to_s
         #@lag3=`#{lang3}`
         @lag3=system lang3
         #if (@lag1.to_s.length) != 3
         #  @lang=@lag1
         #else
         #  if (@lag2.to_s.length) != 3
         #    @lang=@lag2
         #  else
         #    if (@lag3.to_s.length) != 3
         #      @lang=@lag3
         #    else
         #        @lang="wrong"
         #    end
         #  end
         #end
         if (@lag1==true)
           @lang=@lag1
         else
           if (@lag2==true)
             @lang=@lag2
           else
             if (@lag3==true)
               @lang=@lag3
             else
             #  @lang="wrong"
               @lang="wait"
             end
           end
         end
         puts @lang
=end
         @lang="wait"
         if @lang!="wrong"
           an_appcode=Appcode.new(
               :appguid => appguid,
               :zipname => zipfilename,
               :size => dirSize,
               :userguid => userclient.current_user.guid,
               :username => @useremail,
               :appname => @appname,
               :version => version,
               :uploaddate=>Time.now,
               :active=>true,
               :appdetect=> @lang)
           an_appcode.save

           selector={:userid => session[:curuseremail], :appid => @appname}
           @allappinfs=Appcode.where({appguid:appguid}).all
           @allappinfs.each do |allappinf|
             if allappinf.zipname!=zipfilename
               allappinf.active="f"
               allappinf.save
             end
           end
           @nowapp=App.find_by_appguid appguid
           @nowapp.version=an_appcode.version
           @nowapp.uploaddate=an_appcode.uploaddate
           @nowapp.zipfilename=an_appcode.zipname
           @nowapp.appframework=an_appcode.appdetect
           @nowapp.save
           act="应用"+@appname.to_s+"代码包上传后识别成功"
           #createlog act
           return "success"
         else
           act="应用"+@appname.to_s+"代码包上传后识别失败"
           File.delete(@zippath.to_s)
           #createlog act
           return "detectfail"
         end
       end
     else
       act="应用"+@appname.to_s+"代码包上传后识别失败"
       File.delete(@zippath.to_s)
       #createlog act
       return "upfail"
     end



   end



   def initapp client, name, instancenum, space, size
     app=client.app
     app.name = name
     app.total_instances = instancenum.to_i
     app.space = space
     app.memory = size.to_i
     appre=app.create!
     return app
   end

   def find_or_create_route domain, host, space
     route=find_route(domain, host)
     if route==nil
       route=create_route(domain, host, space)
     end
     return route
   end

   def find_route(domain, host)
     client=session[:userclient]
     client.routes_by_host(host, :depth => 0).find { |r| r.domain == domain }
   end

   def create_route domain, host, space
     puts "************************"+domain.to_s
     client=session[:userclient]
     route = client.route
     route.host = host
     #choose a domain from space
     route.domain = domain
     route.space = space
     begin
       route.create!
     rescue Exception => e
       route="sorry"
       puts "-------------------------"+e.to_s
     end
     route
   end

   def createlog detail
     #@aclog=Action.new
     #@aclog.ip=session[:userip]
     #@aclog.date=Time.now
     #@aclog.user=session[:curuseremail]
     #@aclog.act=detail
     #@aclog.save
   end


end
