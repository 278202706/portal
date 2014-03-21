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
         #commd='export BUILDPACK_CACHE=~/build_dir/cache'
         # @com=system commd
         lang1="~/build_dir/target/dea_ng/buildpacks/vendor/ruby/bin/detect "+@path.to_s
         begin
         @lag1=system lang1
         rescue Execption=>e
         puts lang1.to_s+"1"+e.to_s
         end
         puts "----------------------------"
         puts @lag1.to_s+"2"
         lang2="~/build_dir/target/dea_ng/buildpacks/vendor/java/bin/detect "+@path.to_s
         @lag2=system lang2
         lang3="~/build_dir/target/dea_ng/buildpacks/vendor/nodejs/bin/detect "+@path.to_s
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
           @lang="Ruby/Rack"
         else
           if (@lag2==true)
             @lang="Java/Web"
           else
             if (@lag3==true)
               @lang="Nodejs"
             else
               #  @lang="wrong"
               @lang="invalid"
             end
           end
         end
         puts @lang.to_s+"3"
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
         #@lang="wait"
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

   def addapplog appid,log
     @newaplog=Appstartpro.new
     @newaplog.appid=appid
     @newaplog.username=session[:useremail]
     @newaplog.log=log
     @newaplog.token='no'
     @newaplog.save
   end


   @@indentation = 0

   def indented
     @@indentation += 1
     yield
   ensure
     @@indentation -= 1
   end

   def line(msg = "")
     return puts "" if msg.empty?

     start_line(msg)
     puts ""
   end

   def start_line(msg)
     print "  " * @@indentation unless quiet?
     print msg
   end

   def lines(blob)
     blob.each_line do |line|
       start_line(line)
     end

     line
   end

   APP_CHECK_LIMIT = 480
   def startheapp theapp
     app=theapp
     if app.started?
       logs="Application #{app.name} is already started."
       puts "Application #{app.name} is already started."
       addapplog app.guid,logs
     end
     log = start_app(app)
     #stream_start_log(log) if log
     check_application(app)

   end


   def start_app(app)
     log = nil
     logs="Preparing to start #{app.name}"
     addapplog app.guid,logs
     puts "Preparing to start #{app.name}"
       app.start! do |url|
         log = url
         puts url.to_s
       end

     log
   end

   def check_application(app)
     if app.debug == "suspend"
       puts "Application is in suspended debugging mode."
       puts "It will wait for you to attach to it before starting."
       return
     end

     print("Checking status of app '#{app.name}'...")
     logs= "Checking status of app '#{app.name}'..."
     addapplog app.guid,logs
     seconds = 0
     @first_time_after_staging_succeeded = true

     begin
       instances = []
       while true
         puts (any_instance_flapping?(instances)).to_s
         if any_instance_flapping?(instances) || seconds == APP_CHECK_LIMIT
           puts "Push unsuccessful."
           logs="Push unsuccessful."
           addapplog app.guid,logs
           puts "TIP: The system will continue to attempt restarting all requested app instances that have crashed. Try refresh to monitor app status."
           logs="TIP: The system will continue to attempt restarting all requested app instances that have crashed. Try refresh to monitor app status."
           addapplog app.guid,logs
           return
         end

         begin
           return unless instances = app.instances

           indented { print_instances_summary(instances,app) }

           if one_instance_running?(instances)
             puts "#{"Push successful! App '#{app.name}' available at #{app.host}.#{app.domain}"}"
             logs="#{"Push successful! App '#{app.name}' available at #{app.host}.#{app.domain}"}"
             addapplog app.guid,logs
             unless all_instances_running?(instances)
               puts "#{"TIP: The system will continue to start all requested app instances. Try refresh to monitor app status."}"
               logs="#{"TIP: The system will continue to start all requested app instances. Try refresh to monitor app status."}"
               addapplog app.guid,logs
             end
             return
           end
         rescue CFoundry::NotStaged
           #rescue Exception=>e
           print (".")
           #puts e.to_s
          # logs='App has not finish staging. Please wait for a while'
          # addapplog app.guid,logs
         end

         sleep 2
         seconds += 1
       end
     rescue CFoundry::StagingError
       puts "Application failed to stage"
       logs="Application failed to stage"
       addapplog app.guid,logs
     end
   end

   def one_instance_running?(instances)
     puts  "one_instance_running"
     instances.any? { |i| i.state == "RUNNING" }
   end

   def all_instances_running?(instances)
     puts  "all_instance_running"
     instances.all? { |i| i.state == "RUNNING" }
   end

   def any_instance_flapping?(instances)
     puts  "any_instance_flapping"
     instances.any? { |i| i.state == "FLAPPING" }
   end

   def print_instances_summary(instances,app)
     puts  "print_instances_summary"
     if @first_time_after_staging_succeeded
       line
       @first_time_after_staging_succeeded = false
     end

     counts = Hash.new { 0 }
     instances.each do |i|
       counts[i.state] += 1
     end

     states = []
     %w{RUNNING STARTING FLAPPING DOWN}.each do |state|
       if (num = counts[state]) > 0
         states << "#{num} #{for_output(state)}"
         puts "////////////////////////"
         puts state
       end
     end

     total = instances.count
     running = counts["RUNNING"].to_s.rjust(total.to_s.size)

     ratio = "#{running}#{" of "}#{total} instances running"
     puts "#{ratio} (#{states.join(", ")})"
     logs="#{ratio} (#{states.join(", ")})"
     addapplog app.guid,logs
   end



   private
   def for_output(state)
     state = "CRASHING" if state == "FLAPPING"
     state.downcase
   end
end
