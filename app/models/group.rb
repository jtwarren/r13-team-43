class Group
  include MongoMapper::Document

  many :challenges
  many :user_points

  key :name, String, required: true
  key :description, String
  key :image_url, String

  userstamps!
  timestamps!

  scope :recent, sort(:created_at.desc).limit(5)

  def users
    User.where(group_ids: id).all
  end

  def add_user(user)
    user.groups << self
    user_point = UserPoint.where(group_id: self.id, user_id: user.id).first

    unless user_point
      self.user_points.create!(user: user, points: 0)
    end

    user.save!
  end
end
