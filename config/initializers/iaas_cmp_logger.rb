=begin
class CmpLogger < Logger
  def format_message(severity, timestamp, progname, msg)
      "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n"
  end
=end
worker_logfile = File.open("#{Rails.root}/log/cmp.log", 'a')
worker_logfile.sync = true
WORKER_LOG = Iaas::CmpLogger.new(worker_logfile)
