class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :micropost

  has_attached_file :image, styles: { large: '620x400>', medium: '300x200>', small: '100x100#' }
end
