set :application, 'challenge_me'
set :repo_url, "git@github.com:railsrumble/r13-team-43.git"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/apps/challenge_me'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/sockets vendor/bundle}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"
SSHKit.config.command_map[:unicorn] = "#{shared_path}/unicorn/unicorn"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :unicorn, 'restart'

      # Copy freaking glyphicons unhashed into the public assets path.
      execute "cp #{current_path}/app/assets/fonts/twitter/bootstrap/* #{current_path}/public/assets/twitter/bootstrap/"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
