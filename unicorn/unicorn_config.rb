worker_processes 3

user "deploy"

working_directory "/var/www/apps/challenge_me/current"

listen "/var/www/apps/challenge_me/shared/tmp/sockets/unicorn.sock", :backlog => 1024, :tcp_nodelay => true, :tcp_nopush => false, :tries => 5, :delay => 0.5, :accept_filter => "httpready"

timeout 60

pid "/var/www/apps/challenge_me/shared/tmp/pids/unicorn.pid"

stderr_path "/var/www/apps/challenge_me/shared/log/unicorn.stderr.log"
stdout_path "/var/www/apps/challenge_me/shared/log/unicorn.stdout.log"

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

# ensure Unicorn doesn't use a stale Gemfile when restarting
# more info: https://willj.net/2011/08/02/fixing-the-gemfile-not-found-bundlergemfilenotfound-error/
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "/var/www/apps/challenge_me/current/Gemfile"
end

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "/var/www/apps/challenge_me/shared/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end