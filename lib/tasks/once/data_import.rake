# frozen_string_literal: true

namespace :once do
  namespace :data_import do
    desc 'Import servers data'
    task :servers, [:path] => :environment do |_task, args|
      path = args[:path]
      if path.blank?
        puts 'Error: Expected path to CSV file as argument'
        exit 1
      end

      csv = CSV.read(path)
      total = csv.size
      puts "Importing #{total} servers data from `#{path}`"

      ActiveRecord::Base.transaction do
        csv.each.with_index(1) do |arr, index|
          external_id = arr[0].to_i
          dj_role = arr[1]&.to_i
          language = arr[2]
          autopause = arr[3] == 't'
          prefix = arr[4]
          tracks_amount = arr[5].to_i
          tracks_length = arr[6].to_i

          server = DiscordServer.find_or_create_by(external_id: external_id)
          server.setting.update(dj_role: dj_role, language: language, autopause: autopause, prefix: prefix)
          server.statistic.update(tracks_amount: tracks_amount, tracks_length: tracks_length)

          puts "Added #{index}/#{total} servers (#{100 * index / total}%)" if index % 100 == 0
        end
      end
    end

    desc 'Import donations data'
    task :donations, [:path] => :environment do |_task, args|
      path = args[:path]
      if path.blank?
        puts 'Error: Expected path to CSV file as argument'
        exit 1
      end

      csv = CSV.read(path)
      total = csv.size
      puts "Importing #{total} donations data from `#{path}`"

      ActiveRecord::Base.transaction do
        csv.each.with_index(1) do |arr, index|
          server_id = arr[0].to_i
          user_id = arr[1]&.to_i
          date = arr[2].to_date

          server = DiscordServer.find_or_create_by(external_id: server_id)
          user = user_id.nil? ? nil : DiscordUser.find_or_create_by(external_id: user_id)
          Donation.create(size: 0, date: date, discord_server_id: server&.id, discord_user_id: user&.id)

          puts "Added #{index}/#{total} servers (#{100 * index / total}%)" if index % 100 == 0
        end
      end
    end
  end
end
