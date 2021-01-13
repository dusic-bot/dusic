# frozen_string_literal: true

namespace :puma do
  desc 'Get Puma service status via systemd'
  task :status do
    on roles(:web) do
      execute '/bin/systemctl status puma'
    end
  end
end
