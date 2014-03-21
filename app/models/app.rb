class App < ActiveRecord::Base
  attr_accessible :org,:space,:userguid,:username,:appguid,:zipfilename,:version,:appname,:appframework,:active,:uploaddate
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

  def printb name
    puts "+++++++++++++++++++++++++++++++++++++++++++"+name.to_s
  end


  def addapplog appid,log,username
    @newaplog=Appstartpro.new
    @newaplog.appid=appid
    @newaplog.username=username
    @newaplog.log=log
    @newaplog.token='no'
    @newaplog.save
  end


  APP_CHECK_LIMIT = 480
  def startheapp(app,username)
    if app.started?
      logs="Application #{app.name} is already started."
      puts "Application #{app.name} is already started."
      addapplog app.guid,logs,username
    end
    log = start_app(app,username)
    #stream_start_log(log) if log
    check_application(app,username)

  end


  def start_app(app,username)
    log = nil
    logs="Preparing to start #{app.name}"
    addapplog app.guid,logs,username
    puts "Preparing to start #{app.name}"
    app.start! do |url|
      log = url
      puts url.to_s
    end

    log
  end

  def check_application(app,username)
    if app.debug == "suspend"
      puts "Application is in suspended debugging mode."
      puts "It will wait for you to attach to it before starting."
      return
    end

    print("Checking status of app '#{app.name}'...")
    logs= "Checking status of app '#{app.name}'..."
    addapplog app.guid,logs,username
    seconds = 0
    @first_time_after_staging_succeeded = true

    begin
      instances = []
      while true
        puts (any_instance_flapping?(instances)).to_s
        if any_instance_flapping?(instances) || seconds == APP_CHECK_LIMIT
          puts "Push unsuccessful."
          logs="Push unsuccessful."
          addapplog app.guid,logs,username
          puts "TIP: The system will continue to attempt restarting all requested app instances that have crashed. Try refresh to monitor app status."
          logs="TIP: The system will continue to attempt restarting all requested app instances that have crashed. Try refresh to monitor app status."
          addapplog app.guid,logs,username
          return
        end

        begin
          return unless instances = app.instances

          indented { print_instances_summary(instances,app,username) }

          if one_instance_running?(instances)
            puts "#{"Push successful! App '#{app.name}' available at #{app.host}.#{app.domain}"}"
            logs="#{"Push successful! App '#{app.name}' available at #{app.host}.#{app.domain}"}"
            addapplog app.guid,logs,username
            unless all_instances_running?(instances)
              puts "#{"TIP: The system will continue to start all requested app instances. Try refresh to monitor app status."}"
              logs="#{"TIP: The system will continue to start all requested app instances. Try refresh to monitor app status."}"
              addapplog app.guid,logs,username
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
      addapplog app.guid,logs,username
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

  def print_instances_summary(instances,app,username)
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
    addapplog app.guid,logs,username
  end


  def getinfos(curemail,guid)
    appinfos=Appstartpro.where({:username=>curemail,:appid=>guid,:token=>"no"}).all
    appinfos.each do |info|
      info.token="yes"
      info.save
    end
    return appinfos
  end


  private
  def for_output(state)
    state = "CRASHING" if state == "FLAPPING"
    state.downcase
  end
end
