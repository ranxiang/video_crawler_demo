ActiveAdmin.register Video do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  index do
    id_column
    column :name do |video|
      link_to(video.name, video.origin_link, target: "_blank")
    end
    column :desc
    column :creator_name
    column :num_of_views
    column :num_of_comments
    actions do |video|
      link_to("Preview", video.relative_file_url, target: "_blank")
    end
  end

end
