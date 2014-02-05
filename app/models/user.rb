class User < ActiveRecord::Base
  D1 = BigDecimal.new(1)
  D2 = BigDecimal.new(2)
  D100 = BigDecimal.new(100)

  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :matches_by_user_initiator, foreign_key: "initiator_id",
                             class_name: "Match"
  has_many :matches_by_user_invited, foreign_key: "invited_id",
                             class_name: "Match"
  has_attached_file :avatar, :styles => { :large => '300x>', :medium => "130x130>", :thumb => "100x100>", xs: "50x50#", xxs: "30x30#" }, 
                    :default_url => "/images/missing_:style.png"
# to implement it with new avatars run in console: User.all.each { |u| u.avatar.reprocess! if u.avatar? }

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 3 }
  
  def matches
    (matches_by_user_initiator + matches_by_user_invited).sort_by(&:created_at).reverse
  end

  def feed
    Micropost.from_users_followed_by(self)
  end  

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def corrected_robustness
    result = if robustness <= 30
        30
      elsif robustness > 350
        350
      else
        robustness
      end

    BigDecimal.new(result)
  end

  def corrected_rating
    if rating == 0
      BigDecimal.new("450")
    else
      BigDecimal.new(rating)
    end
  end

  def probability(opponent)
    (D1/(D1 + D2**((opponent.corrected_rating - corrected_rating)/D100))).round(6)
  end

  def update_rating_by(delta)
    self.rating = corrected_rating + delta
  end

  def place
    if rating == 0
      0
    else
      User.order('rating DESC').index(self) + 1
    end
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end	
