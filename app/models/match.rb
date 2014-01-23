class Match < ActiveRecord::Base
  belongs_to :initiator, class_name:'User'
  belongs_to :invited, class_name:'User'

  default_scope -> { order('created_at DESC') }
  validates :initiator_id, presence: true
  validates :invited_id, presence: true
  validates :status, presence: true
  
  validates :wins, presence: true, if: :status_finished?, length: { maximum: 2 }
  validates :loses, presence: true, if: :status_finished?, length: { maximum: 2 }

  before_save :update_rating

  def status_finished?
    status == "finished"
  end

  def games
    wins + loses
  end

  def update_rating
    if status_finished?
      initiator.robustness += games
      invited.robustness += games

      r1 = initiator.corrected_robustness
      r2 = invited.corrected_robustness 

      p1 = initiator.probability(invited)
      p2 = invited.probability(initiator)
    
      initiator.update_rating_by (630.0 * (wins - p1 * games) * ((r2 - games)/(r1 * r2))).round
      invited.update_rating_by (630.0 * (loses - p2 * games) * ((r1 - games)/(r1 * r2))).round

      initiator.save
      invited.save

puts initiator.errors.inspect      
puts invited.errors.inspect
    end
  end
  
end
