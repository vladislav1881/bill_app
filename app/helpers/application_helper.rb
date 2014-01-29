module ApplicationHelper
  def full_title(page_title)
    base_title = "Billiard App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def link_to_photo(photo)
    link_to image_tag(photo.image.url(:small)), photo
  end
end
