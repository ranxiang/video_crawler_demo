json.array!(@videos) do |video|
  json.extract! video, :id, :name, :desc, :origin_link, :creator_name, :creator_desc, :num_of_views, :num_of_comments
  json.url video_url(video, format: :json)
end
