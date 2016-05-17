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

  def sync_with_origin

    browser = Selenium::WebDriver.for :phantomjs
    browser.get(origin_link)
    doc = Nokogiri::HTML(browser.page_source)
    browser.close

    self.name = doc.css('.watch-page .title').first.inner_html.strip
    self.desc = doc.css('#video-description').first.inner_html.strip
    self.creator_name = doc.css('.channel-title span a').first.inner_html.strip

    # creator_desc, nothing found in origin page about this column

    self.num_of_views = doc.css('#like-dislike-bar .views').inner_html.split(' ').first

    comments = JSON.load(open("http://www.vrideo.com/api/v1/videos/#{source_video_id}/comments?get_meta_data=1"))
    self.num_of_comments = comments['data']['total']

    # TODO store video file to local

    File.open("#{Rails.root}/public/videos/#{source_video_id}.mp4", "wb") do |saved_file|
      open(source_video_file_link, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end

    self.save!
  end
end
