namespace :crawler do
  desc "TODO"
  task batch_update_newest_video_basic_info: :environment do
    Rails.logger       = Logger.new(Rails.root.join('log', 'update_newest_video_basic_info.log'))
    Rails.logger.level = Logger.const_get((ENV['LOG_LEVEL'] || 'debug').upcase)
    if ENV['BACKGROUND']
      Process.daemon(true, true)
    end

    File.open(ENV['PIDFILE'] || 'update_newest_video_basic_info.pid', 'w') { |f| f << Process.pid }
    Signal.trap('TERM') { abort }

    Rails.logger.info "Start daemon..."
    loop do
      # Daemon code goes here...
      Rails.logger.info "Start next round update at: #{DateTime.now}"
      Video.batch_update_newest_video_basic_info
      sleep ENV['INTERVAL'] || rand(60..180)
    end
  end

  desc "TODO"
  task batch_sync_videos: :environment do
    Rails.logger       = Logger.new(Rails.root.join('log', 'batch_sync_videos.log'))
    Rails.logger.level = Logger.const_get((ENV['LOG_LEVEL'] || 'debug').upcase)
    if ENV['BACKGROUND']
      Process.daemon(true, true)
    end

    File.open(ENV['PIDFILE'] || 'batch_sync_videos.pid', 'w') { |f| f << Process.pid }
    Signal.trap('TERM') { abort }

    Rails.logger.info "Start daemon..."
    loop do
      # Daemon code goes here...
      Rails.logger.info "Start next round update at: #{DateTime.now}"
      begin
        Video.sync_next_video
      rescue StandardError => e
        Rails.logger.error "Error happened at: #{DateTime.now}"
        Rails.logger.error e.backtrace.inspect
      end
      sleep ENV['INTERVAL'] || rand(2..5)
    end
  end

  desc "TODO"
  task batch_sync_num_of_views_and_comments: :environment do
    Video.batch_sync_num_of_views_and_comments
  end

end
