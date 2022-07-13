set :repo_url,        "git@github.com:venky-ror/dummy_app.git"
set :application,     "dummy_app"
set :user,            "ubuntu"
set :puma_threads,    [4, 25]
set :puma_workers,    0

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
set :deploy_to,       "/home/#{fetch(:user)}/ror/#{fetch(:application)}"
set :puma_bind,       %w[tcp://0.0.0.0:9292 unix://#{shared_path}/tmp/sockets/#{fetch(:application)}_puma.sock]
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false

## Defaults:
set :scm,           :git
set :branch,        :master

set :format,        :pretty
set :log_level,     :debug
set :keep_releases, 5

set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml',
  'config/cable.yml',
  'config/master.key',
  'config/sidekiq.yml'
  # 'config/storage.yml'
)
set :bundle_binstubs, nil
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      puts "#{current_path}"
      within "#{current_path}" do
        with :rails_env => :production do
          execute :rake, "initiate_library:dep"
          execute :rake, "sidekiq:stop"
          execute :rake, "sidekiq:restart"
        end
      end
    end

    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end