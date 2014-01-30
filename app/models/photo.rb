class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :micropost

  validates :image, attachment_presence: true

  has_attached_file :image, styles: { large: '620x400>', medium: '300x200>', medium_square: '200x200#', small: '100x100#' }
end
