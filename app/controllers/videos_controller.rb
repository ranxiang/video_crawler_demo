class VideosController < InheritedResources::Base

  private

    def video_params
      params.require(:video).permit(:name, :desc, :source_type, :source_video_id, :creator_name, :creator_desc, :num_of_views, :num_of_comments, :md5, :last_fetch_date,, :active, :last_metadata_fetch_date)
    end
end

