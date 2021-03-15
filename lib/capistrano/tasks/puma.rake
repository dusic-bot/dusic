# frozen_string_literal: true

namespace :puma do
  desc 'Get Puma service status via systemd'
  task :status do
    on roles(:web) do
      execute '/bin/systemctl status puma'
    end
  end

  desc 'Restart Puma service status via systemd (requires sudo with no password)'
  task :restart do
    on roles(:web) do
      execute 'sudo /bin/systemctl restart puma'
    end
  end
end

after 'deploy:published', 'puma:restart'
