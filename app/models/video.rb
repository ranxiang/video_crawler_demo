require 'open-uri'

class Video < ActiveRecord::Base

  def origin_link
    case source_type
    when 'vrideo'
      "http://www.vrideo.com/watch/#{source_video_id}"
    end
  end

  def source_video_file_link
    case source_type
    when 'vrideo'
      "http://cdn2.vrideo.com/prod_videos/v1/#{source_video_id}_1080p_full.mp4"
    end
  end

  def doc
    return @doc if @doc.present?
    browser = Selenium::WebDriver.for :phantomjs
    browser.get(origin_link)
    @doc = Nokogiri::HTML(browser.page_source)
    browser.close
    @doc
  end

  def set_num_of_views
    self.num_of_views = doc.css('#like-dislike-bar .views').inner_html.split(' ').first
  end

  def set_num_of_comments
    comments = JSON.load(open("http://www.vrideo.com/api/v1/videos/#{source_video_id}/comments?get_meta_data=1"))
    self.num_of_comments = comments['data']['total']
  end

  def set_metadata
    logger.debug "Starting set metadata"

    self.name = doc.css('.watch-page .title').first.inner_html.strip
    self.desc = doc.css('#video-description').first.inner_html.strip
    self.creator_name = doc.css('.channel-title span a').first.inner_html.strip

    set_num_of_views
    set_num_of_comments

    # creator_desc, nothing found in origin page about this column
  end

  def relative_file_url
    "/videos/#{self.md5}.mp4"
  end

  def download_file
    logger.debug "Starting download file"

    file_location_prefix = "#{Rails.root}/public/videos"

    temp_file_name = "#{file_location_prefix}/#{source_type}_#{source_video_id}.mp4"

    # download file and save it in local
    File.open(temp_file_name, "wb") do |saved_file|
      open(source_video_file_link, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end

    # get the md5 of origin file, and we can compare this value to reduce file in future.
    self.md5 = Digest::MD5.file(temp_file_name).to_s
    final_file_name = "#{file_location_prefix}/#{self.md5}.mp4"
    FileUtils.mv(temp_file_name, final_file_name)
    logger.debug "file location is: #{final_file_name}"
  end

  def sync_with_origin
    logger.debug "Starting sync with origin link, at #{DateTime.now}"
    set_metadata
    download_file

    self.save!
    logger.debug "Finished sync, at #{DateTime.now}"
  end
end
