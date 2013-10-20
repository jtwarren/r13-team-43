class Transaction
  include MongoMapper::Document

  timestamps!

  belongs_to :challenge
  belongs_to :user

  key :points
  key :total_points

  validates_presence_of :challenge
  validates_presence_of :user
  validates_presence_of :points
  validates_presence_of :total_points

  # user this method to give some user points for a challenge
  def self.update_user_points(user, challenge, points)
    transaction = new({
      user: user,
      challenge: challenge,
      points: points,
      total_points: user.points(challenge.group),
    })

    transaction.store!
  end

  def group
    challenge.group
  end

  def store!
    save!

    user_point = UserPoint.where(group_id: group.id, user_id: user.id).first

    if user_point.present?
      UserPoint.increment(user_point.id, points: points)
    else
      UserPoint.create!(group: group, user: user, points: points)
    end

    user.reload
    self
  end
end
