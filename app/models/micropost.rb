class Micropost < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :nullify

  default_scope -> { order('created_at DESC') }

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  acts_as_commentable
  
  accepts_nested_attributes_for :photos, reject_if: proc { |attrs| attrs[:image].blank? }

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end

